import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class LupaPasswordController extends GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  Future<void> kirimInstruksi() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await ApiService.to.postRequest('/forgot-password', {
          'email': emailController.text,
        });

        if (response.statusCode == 200 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            final devOtp = body['code']?.toString();
            Get.snackbar(
              'Kode OTP Dikirim',
              'Kode verifikasi OTP telah dikirimkan ke email Anda.',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            // Navigate to OTP page, passing email and optionally devOtp as arguments
            Get.toNamed(
              Routes.OTP_VERIFIKASI,
              arguments: {
                'email': emailController.text,
                'devOtp': devOtp,
              },
            );
            return;
          }
        }

        final errorMsg = (response.body != null && response.body is Map)
            ? response.body['message'] ?? 'Gagal mengirim instruksi reset password'
            : 'Gagal terhubung ke server';

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
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
