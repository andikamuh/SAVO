import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class OtpVerifikasiController extends GetxController {
  final otpControllers = List.generate(4, (_) => TextEditingController());
  final focusNodes = List.generate(4, (_) => FocusNode());

  final secondsRemaining = 59.obs;
  Timer? _timer;
  final canResend = false.obs;
  final isLoading = false.obs;

  String email = '';
  String? devOtp;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
      devOtp = Get.arguments['devOtp']?.toString();
      
      // Pre-fill OTP automatically if devOtp is present (development helper)
      if (devOtp != null && devOtp!.length == 4) {
        for (int i = 0; i < 4; i++) {
          otpControllers[i].text = devOtp![i];
        }
      }
    }
    startTimer();
  }

  void startTimer() {
    canResend.value = false;
    secondsRemaining.value = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;
      } else {
        canResend.value = true;
        _timer?.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (canResend.value) {
      try {
        final response = await ApiService.to.postRequest('/forgot-password', {
          'email': email,
        });

        if (response.statusCode == 200 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            devOtp = body['code']?.toString();
            
            // Re-fill helper if new devOtp returned
            if (devOtp != null && devOtp!.length == 4) {
              for (int i = 0; i < 4; i++) {
                otpControllers[i].text = devOtp![i];
              }
            }

            startTimer();
            Get.snackbar(
              'Kode Dikirim',
              'Kode OTP baru telah dikirimkan ke email Anda.',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
          }
        }
      } catch (e) {
        Get.snackbar(
          'Gagal',
          'Gagal mengirim ulang OTP',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    }
  }

  void nextField(String value, int index) {
    if (value.length == 1 && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> verifikasi() async {
    if (isLoading.value) return;
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 4) {
      isLoading.value = true;
      try {
        final response = await ApiService.to.postRequest('/verify-otp', {
          'email': email,
          'code': otp,
        });

        if (response.statusCode == 200 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            Get.snackbar(
              'Verifikasi Sukses',
              'Email berhasil diverifikasi.',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            Get.toNamed(Routes.PASSWORD_BARU, arguments: email);
            return;
          }
        }

        final errorMsg = (response.body != null && response.body is Map)
            ? response.body['message'] ?? 'Kode OTP salah atau kedaluwarsa'
            : 'Gagal memverifikasi OTP';

        Get.snackbar(
          'Gagal',
          errorMsg,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } catch (e) {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan koneksi',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Gagal',
        'Silahkan lengkapi 4 digit kode OTP Anda.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  String get formattedTime {
    int minutes = secondsRemaining.value ~/ 60;
    int seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
