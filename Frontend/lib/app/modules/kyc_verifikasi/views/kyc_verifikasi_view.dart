import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/kyc_verifikasi_controller.dart';

class KycVerifikasiView extends GetView<KycVerifikasiController> {
  const KycVerifikasiView({Key? key}) : super(key: key);
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
          'SAVO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Langkah 2 dari 3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  'Verifikasi',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Titles
            const Text(
              'Verifikasi Kartu Mahasiswa',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Unggah KTM (Kartu Tanda Mahasiswa) Anda dan selesaikan verifikasi wajah untuk membuka fitur SAVO sepenuhnya.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // KTM Upload Section
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
                  Row(
                    children: const [
                      Icon(Icons.badge_outlined, color: AppColors.textPrimary),
                      SizedBox(width: 8),
                      Text(
                        'Student ID (KTM)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => GestureDetector(
                    onTap: () => controller.showImageSourceSelection(isKtm: true),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: controller.hasKtm ? Colors.green.shade400 : Colors.red.shade100,
                          width: 2,
                          style: BorderStyle.solid, 
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: controller.hasKtm ? Colors.green.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: controller.hasKtm
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      controller.ktmImage.value!,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  )
                                : const Icon(Icons.add_photo_alternate_outlined, color: Colors.grey, size: 40),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            controller.hasKtm 
                              ? 'KTM Berhasil Diunggah' 
                              : 'Ketuk untuk mengambil foto atau memilih KTM Anda.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12, 
                              color: controller.hasKtm ? Colors.green.shade700 : AppColors.textSecondary,
                              fontWeight: controller.hasKtm ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PASTIKAN INFORMASI KARTU JELAS & TERBACA',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.brown.shade300,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Face Verification Section
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
                  Row(
                    children: const [
                      Icon(Icons.face, color: AppColors.textPrimary),
                      SizedBox(width: 8),
                      Text(
                        'Face Verification',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => GestureDetector(
                    onTap: () => controller.showImageSourceSelection(isKtm: false),
                    child: Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: controller.hasSelfie ? Colors.green.shade50 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: controller.hasSelfie 
                            ? Border.all(color: Colors.green.shade400, width: 2)
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Actual selfie preview inside the oval frame, or grey person placeholder
                          controller.hasSelfie
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    width: 150,
                                    height: 180,
                                    child: Image.file(
                                      controller.selfieImage.value!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.person, size: 100, color: Colors.grey),
                          // Oval frame overlay
                          Container(
                            width: 150,
                            height: 180,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.hasSelfie ? Colors.green.shade400 : Colors.brown.withOpacity(0.5), 
                                width: 2
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                controller.hasSelfie ? 'Wajah Terverifikasi' : 'Posisikan wajah Anda di dalam oval',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Privacy Notice
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.lock_outline, size: 16, color: AppColors.textSecondary),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data Anda dienkripsi dengan aman dan hanya digunakan untuk keperluan verifikasi identitas sesuai dengan kebijakan privasi kami.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isUploading.value ? null : () => controller.submitKyc(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.6),
                ),
                child: controller.isUploading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Kirim Verifikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              )),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
