import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isPasswordHidden = true.obs;
  
  final isLoading = false.obs;
  
  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }
    return null;
  }

  Future<void> login() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await ApiService.to.postRequest('/login', {
          'email': emailController.text,
          'password': passwordController.text,
        });

        if (response.statusCode == 200 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            final token = body['token'] as String;
            final user = body['user'] as Map<String, dynamic>;
            final isAdmin = user['is_admin'] == true || user['is_admin'] == 1 || user['is_admin'] == '1';
            final kycStatus = user['kyc_status'] as String? ?? 'none';

            if (!isAdmin && kycStatus != 'approved') {
              ApiService.to.setToken(token);
              
              if (kycStatus == 'pending') {
                Get.snackbar(
                  'Verifikasi Diproses',
                  'Akun Anda sedang dalam proses verifikasi oleh Admin.',
                  backgroundColor: Colors.amber.shade50,
                  colorText: Colors.amber.shade900,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                );
                Get.offAllNamed(Routes.KYC_PENDING);
              } else {
                final isRejected = kycStatus == 'rejected';
                final reason = user['kyc_rejected_reason'] as String?;
                Get.snackbar(
                  isRejected ? 'Verifikasi Ditolak' : 'Verifikasi Dibutuhkan',
                  isRejected 
                      ? 'Verifikasi Anda ditolak: ${reason ?? "Data tidak sesuai"}. Silakan unggah ulang.'
                      : 'Silakan lengkapi verifikasi KTM dan Wajah terlebih dahulu.',
                  backgroundColor: Colors.amber.shade50,
                  colorText: Colors.amber.shade900,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  duration: const Duration(seconds: 4),
                );
                Get.offAllNamed(Routes.KYC_VERIFIKASI);
              }
              return;
            }

            ApiService.to.setToken(token);

            Get.snackbar(
              'Berhasil',
              'Selamat datang kembali di SAVO!',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            Get.offAllNamed(Routes.MAIN);
            return;
          }
        }

        final errorMsg = (response.body != null && response.body is Map) 
            ? response.body['message'] ?? 'Email atau kata sandi salah'
            : 'Gagal terhubung ke server';

        Get.snackbar(
          'Gagal Masuk',
          errorMsg,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } catch (e) {
        Get.snackbar(
          'Gagal Masuk',
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
