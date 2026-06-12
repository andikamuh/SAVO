import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../main/controllers/main_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () {
            // Navigate back to the first tab (Home) in MainView
            try {
              Get.find<MainController>().changeTab(0);
            } catch (e) {
              Get.back();
            }
          },
        ),
        title: const Text(
          'Profil',
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
              // 1. Profile Header / User Info Card
              _buildProfileHeaderCard(),
              const SizedBox(height: 24),

              // 2. Academic Info Section
              _buildSectionTitle('INFORMASI AKADEMIK'),
              const SizedBox(height: 8),
              _buildAcademicCard(),
              const SizedBox(height: 24),

              // 3. Bio Section
              _buildSectionTitle('BIO'),
              const SizedBox(height: 8),
              _buildBioCard(),
              const SizedBox(height: 24),

              // 4. Payment Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('METODE PEMBAYARAN'),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.primaryDark, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Get.toNamed(Routes.PENGATURAN_PEMBAYARAN),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildPaymentCard(),
              const SizedBox(height: 32),

              // 5. Logout Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Logic to clear token and go to Login
                    ApiService.to.setToken(null);
                    Get.offAllNamed(Routes.LOGIN);
                    Get.snackbar(
                      'Logout Berhasil',
                      'Anda telah berhasil keluar dari akun.',
                      backgroundColor: Colors.green.shade50,
                      colorText: Colors.green.shade900,
                      snackPosition: SnackPosition.TOP,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  label: const Text(
                    'Keluar Akun',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildProfileHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
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
        children: [
          // Avatar
          Obx(() => Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryDark.withOpacity(0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.inputBackground,
              backgroundImage: controller.avatarUrl.value.isNotEmpty
                  ? NetworkImage(controller.avatarUrl.value)
                  : null,
              child: controller.avatarUrl.value.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.textSecondary,
                    )
                  : null,
            ),
          )),
          const SizedBox(height: 16),
          // Name
          Obx(() => Text(
                controller.nama.value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 4),
          // Major / Prodi
          Obx(() => Text(
                controller.prodi.value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 12),
          // Rating and Level Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Obx(() => Text(
                          controller.rating.value.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        )),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Helper Terverifikasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Edit Profile Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.EDIT_PROFILE),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text(
                'Edit Profil',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcademicCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
        children: [
          _buildInfoRow(
            icon: Icons.school_outlined,
            title: 'Universitas',
            value: controller.universitas,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.badge_outlined,
            title: 'NIM',
            value: controller.nim,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            icon: Icons.email_outlined,
            title: 'Email Kampus',
            value: controller.emailKampus,
          ),
        ],
      ),
    );
  }

  Widget _buildBioCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
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
      child: Obx(() => Text(
            controller.bio.value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          )),
    );
  }

  Widget _buildPaymentCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PENGATURAN_PEMBAYARAN),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.primaryDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Penerima Pembayaran',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Obx(() => Text(
                            controller.bankName.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          )),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
              ],
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      controller.bankAccount.value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: AppColors.textPrimary,
                      ),
                    )),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.copy_outlined,
                    color: AppColors.primaryDark,
                    size: 18,
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: controller.bankAccount.value));
                    Get.snackbar(
                      'Salin',
                      'Nomor e-wallet/rekening berhasil disalin!',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.primaryDark,
                      colorText: AppColors.white,
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                      duration: const Duration(seconds: 2),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required RxString value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                    value.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
