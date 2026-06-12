import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class PasswordBaruController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final hasAtLeast8Chars = false.obs;
  final hasUpperAndLowerCase = false.obs;
  final hasAtLeast1Number = false.obs;

  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  String email = '';

  @override
  void onInit() {
    super.onInit();
    passwordController.addListener(_onPasswordChanged);
    if (Get.arguments is String) {
      email = Get.arguments;
    } else if (Get.arguments is Map) {
      email = Get.arguments['email'] ?? '';
    }
  }

  void _onPasswordChanged() {
    final text = passwordController.text;

    // Check at least 8 characters
    hasAtLeast8Chars.value = text.length >= 8;

    // Check upper and lower case
    hasUpperAndLowerCase.value = text.contains(RegExp(r'[A-Z]')) && text.contains(RegExp(r'[a-z]'));

    // Check at least 1 number
    hasAtLeast1Number.value = text.contains(RegExp(r'[0-9]'));
  }

  void togglePasswordHidden() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordHidden() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kata sandi tidak boleh kosong';
    }
    if (!hasAtLeast8Chars.value || !hasUpperAndLowerCase.value || !hasAtLeast1Number.value) {
      return 'Kata sandi belum memenuhi kriteria aman';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi kata sandi tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }

  Future<void> simpanPassword() async {
    if (isLoading.value) return;
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final response = await ApiService.to.postRequest('/reset-password', {
          'email': email,
          'password': passwordController.text,
        });

        if (response.statusCode == 200 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            Get.snackbar(
              'Berhasil',
              'Password baru Anda telah berhasil dibuat. Silahkan login kembali.',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            Get.offAllNamed(Routes.LOGIN);
            return;
          }
        }

        final errorMsg = (response.body != null && response.body is Map)
            ? response.body['message'] ?? 'Gagal mengatur ulang kata sandi'
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
    } else {
      Get.snackbar(
        'Gagal',
        'Periksa kembali kata sandi dan pastikan kriteria terpenuhi.',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  void onClose() {
    passwordController.removeListener(_onPasswordChanged);
    super.onClose();
  }
}
