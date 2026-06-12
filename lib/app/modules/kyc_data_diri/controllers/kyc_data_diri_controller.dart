import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';

class KycDataDiriController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nimController = TextEditingController();
  final universitasController = TextEditingController();
  final prodiController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isTermsAccepted = false.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final isLoading = false.obs;

  final formKey = GlobalKey<FormState>();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    return null;
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

  String? validateNim(String? value) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }
    return null;
  }

  String? validateUniversitas(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama universitas tidak boleh kosong';
    }
    return null;
  }

  String? validateProdi(String? value) {
    if (value == null || value.isEmpty) {
      return 'Program studi tidak boleh kosong';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    if (value != passwordController.text) {
      return 'Konfirmasi password tidak cocok';
    }
    return null;
  }

  Future<void> register() async {
    if (isLoading.value) return;

    if (!isTermsAccepted.value) {
      Get.snackbar(
        'Peringatan',
        'Anda harus menyetujui Syarat & Ketentuan',
        backgroundColor: Colors.amber.shade50,
        colorText: Colors.amber.shade900,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        final response = await ApiService.to.postRequest('/register', {
          'name': nameController.text,
          'email': emailController.text,
          'nim': nimController.text,
          'password': passwordController.text,
          'universitas': universitasController.text,
          'prodi': prodiController.text,
        });

        if (response.statusCode == 201 && response.body != null) {
          final body = response.body as Map<String, dynamic>;
          if (body['status'] == 'success') {
            final token = body['token'] as String;
            ApiService.to.setToken(token);

            Get.snackbar(
              'Berhasil',
              'Registrasi berhasil!',
              backgroundColor: Colors.green.shade50,
              colorText: Colors.green.shade900,
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            // Move to step 2 of KYC (Verifikasi / upload docs)
            Get.offAllNamed(Routes.KYC_VERIFIKASI);
            return;
          }
        }

        final errorMsg = (response.body != null && response.body is Map)
            ? response.body['message'] ?? 'Gagal melakukan registrasi'
            : 'Gagal terhubung ke server';

        Get.snackbar(
          'Gagal Registrasi',
          errorMsg,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      } catch (e) {
        Get.snackbar(
          'Gagal Registrasi',
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
