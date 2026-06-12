import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/password_baru_controller.dart';

class PasswordBaruView extends GetView<PasswordBaruController> {
  const PasswordBaruView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Header Logo
                const Center(
                  child: Text(
                    'SAVO',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                const Text(
                  'Buat Password Baru',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                // Subtitle
                const Text(
                  'Silahkan masukkan password baru Anda. Pastikan password kuat dan mudah diingat.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 28),
                // Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      const Text(
                        'Password Baru',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Password Field
                      Obx(
                        () => TextFormField(
                          controller: controller.passwordController,
                          validator: controller.validatePassword,
                          obscureText: controller.isPasswordHidden.value,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Password Baru',
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: controller.togglePasswordHidden,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Label
                      const Text(
                        'Konfirmasi Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Confirm Password Field
                      Obx(
                        () => TextFormField(
                          controller: controller.confirmPasswordController,
                          validator: controller.validateConfirmPassword,
                          obscureText: controller.isConfirmPasswordHidden.value,
                          decoration: InputDecoration(
                            hintText: 'Ulangi Password Baru',
                            hintStyle: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_reset_outlined,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordHidden.value
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onPressed: controller.toggleConfirmPasswordHidden,
                            ),
                            filled: true,
                            fillColor: AppColors.inputBackground,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Password Criteria Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kriteria Password Aman:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildCriteriaItem(
                        text: 'Minimal 8 karakter',
                        checkObservable: controller.hasAtLeast8Chars,
                      ),
                      const SizedBox(height: 8),
                      _buildCriteriaItem(
                        text: 'Kombinasi huruf besar & kecil',
                        checkObservable: controller.hasUpperAndLowerCase,
                      ),
                      const SizedBox(height: 8),
                      _buildCriteriaItem(
                        text: 'Mengandung minimal 1 angka',
                        checkObservable: controller.hasAtLeast1Number,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Simpan Password Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isLoading.value ? null : controller.simpanPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.6),
                        disabledForegroundColor: AppColors.white.withOpacity(0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 0,
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                              ),
                            )
                          : const Text(
                              'Simpan Password Baru',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCriteriaItem({
    required String text,
    required RxBool checkObservable,
  }) {
    return Obx(() {
      final isMet = checkObservable.value;
      return Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.check_circle_outline,
            color: isMet ? Colors.green.shade600 : AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: isMet ? Colors.green.shade900 : AppColors.textSecondary,
              fontWeight: isMet ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      );
    });
  }
}
