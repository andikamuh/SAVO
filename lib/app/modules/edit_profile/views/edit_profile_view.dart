import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Interactive Profile Photo Editor
              Center(
                child: Stack(
                  children: [
                    Obx(() {
                      final hasLocal = controller.isAvatarChanged.value;
                      final networkUrl = controller.profileController.avatarUrl.value;
                      return Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryDark.withOpacity(0.2), width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.inputBackground,
                          backgroundImage: hasLocal
                              ? MemoryImage(controller.avatarBytes.value!) as ImageProvider
                              : (networkUrl.isNotEmpty ? NetworkImage(networkUrl) : null),
                          child: (!hasLocal && networkUrl.isEmpty)
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textSecondary,
                                )
                              : null,
                        ),
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => controller.selectNewAvatar(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // 1. General Profile Info Header
              const Text(
                'INFORMASI PENGGUNA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              
              // Info Card Container
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
                    _buildInputLabel('Nama Lengkap'),
                    _buildEditableTextField(
                      controller: controller.nameController,
                      hint: 'Masukkan nama lengkap',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 16),

                    _buildInputLabel('Program Studi'),
                    _buildEditableTextField(
                      controller: controller.prodiController,
                      hint: 'Masukkan program studi',
                      icon: Icons.school_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildInputLabel('Bio'),
                    _buildEditableTextField(
                      controller: controller.bioController,
                      hint: 'Ceritakan singkat tentang diri Anda...',
                      icon: Icons.info_outline,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Locked Academic Info Section
              const Text(
                'DATA KAMPUS (TERKUNCI)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              
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
                    _buildInputLabel('Universitas'),
                    _buildLockedTextField(
                      value: controller.profileController.universitas.value,
                      icon: Icons.account_balance_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildInputLabel('NIM'),
                    _buildLockedTextField(
                      value: controller.profileController.nim.value,
                      icon: Icons.badge_outlined,
                    ),
                    const SizedBox(height: 16),

                    _buildInputLabel('Email Kampus'),
                    _buildLockedTextField(
                      value: controller.profileController.emailKampus.value,
                      icon: Icons.email_outlined,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Payment Info Section
              const Text(
                'METODE PEMBAYARAN',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),

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
                    _buildInputLabel('Pilih Bank / E-Wallet'),
                    Obx(() => _buildDropdownField()),
                    const SizedBox(height: 16),

                    _buildInputLabel('Nomor Rekening / E-Wallet'),
                    _buildEditableTextField(
                      controller: controller.accountController,
                      hint: 'Contoh: 08123456789',
                      icon: Icons.account_balance_wallet_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Obx(() {
            final loading = controller.isLoading.value;
            return ElevatedButton(
              onPressed: loading ? null : () => controller.saveChanges(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Simpan Perubahan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLockedTextField({
    required String value,
    required IconData icon,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      readOnly: true,
      enabled: false,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.grey.shade400, size: 20),
        suffixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400, size: 20),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: controller.selectedBank.value,
      items: controller.bankOptions.map((String bank) {
        return DropdownMenuItem<String>(
          value: bank,
          child: Text(
            bank,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          controller.selectedBank.value = newValue;
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.account_balance_outlined, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.inputBackground,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
