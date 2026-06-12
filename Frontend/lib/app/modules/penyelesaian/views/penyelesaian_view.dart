import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/penyelesaian_controller.dart';

class PenyelesaianView extends GetView<PenyelesaianController> {
  const PenyelesaianView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryDark),
          onPressed: () => Get.back(),
        ),
        title: Column(
          children: [
            const Text(
              'Penyelesaian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Obx(() => Text(
              'ID: GIG-${controller.gigId.value}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            )),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ringkasan Pekerjaan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() {
                                final text = controller.title.value;
                                final display = text.length > 20 ? "${text.substring(0, 18)}..." : text;
                                return Text(
                                  display,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                );
                              }),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.school_outlined, color: AppColors.textSecondary, size: 14),
                                  const SizedBox(width: 6),
                                  Obx(() => Text(
                                    controller.category.value,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Obx(() => Text(
                          controller.price.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    // Poster Row
                    Row(
                      children: [
                        Obx(() => CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: NetworkImage(controller.requesterAvatar.value),
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        )),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Text(
                              controller.requesterName.value,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            )),
                            const SizedBox(height: 2),
                            const Text(
                              'Peminta Jasa',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Laporan Pekerjaan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.check_circle_outline, color: AppColors.textPrimary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Laporan Pekerjaan (Helper)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Unggah bukti foto hasil pekerjaan Anda untuk diperiksa oleh peminta jasa.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Upload area
                    GestureDetector(
                      onTap: () => controller.uploadPhoto(),
                      child: Obx(() {
                        final uploaded = controller.photoUploaded.value;
                        final imageFile = controller.evidenceImage.value;
                        return Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: uploaded ? Colors.green.shade50.withOpacity(0.3) : const Color(0xFFF9F6F6),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: uploaded ? Colors.green.shade400 : Colors.red.shade100,
                              style: BorderStyle.solid,
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: imageFile != null
                                ? Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        File(imageFile.path),
                                        fit: BoxFit.cover,
                                      ),
                                      Container(
                                        color: Colors.black.withOpacity(0.3),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: const [
                                              Icon(Icons.check_circle, color: Colors.green, size: 44),
                                              SizedBox(height: 8),
                                              Text(
                                                'Tap untuk mengubah foto',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_a_photo_outlined,
                                          color: Colors.grey.shade400,
                                          size: 44,
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Tap untuk unggah foto hasil',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        const Text(
                                          '(Maks. 5MB)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Tandai Selesai Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: Obx(() {
                        final isDone = controller.isTandaiSelesai.value;
                        return ElevatedButton(
                          onPressed: () => controller.markDone(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDone ? Colors.green : AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            isDone ? 'Sudah Ditandai Selesai' : 'Tandai Selesai',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(() {
            final active = controller.isTandaiSelesai.value;
            return ElevatedButton(
              onPressed: active ? () => controller.finish() : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: active ? AppColors.primaryDark : Colors.grey.shade300,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: active ? 4 : 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Selesai',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.play_arrow_outlined, size: 18),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
      border: Border.all(color: Colors.grey.shade100),
    );
  }
}
