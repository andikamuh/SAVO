import 'dart:io';
import 'dart:ui' show PathMetric;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Laporkan Pengguna',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
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
              // Deskripsi Singkat
              const Text(
                'Bantu Komunitas SAVO',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Silakan laporkan segala bentuk pelanggaran atau kecurangan. Laporan Anda akan diperiksa secara manual oleh Admin.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Warning Banner (Alert Box)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100, width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PENTING: Laporan Palsu',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Setiap laporan akan ditinjau secara serius. Tindakan memberikan laporan palsu dapat mengakibatkan akun Anda ditangguhkan secara permanen.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.red.shade700,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Gig Selector Dropdown (only visible when opened from general menu without gig arguments)
              Obx(() {
                if (controller.myGigs.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih Pekerjaan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<dynamic>(
                      isExpanded: true,
                      value: controller.selectedGig.value,
                      hint: const Text(
                        'Pilih pekerjaan yang bermasalah...',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      decoration: InputDecoration(
                        fillColor: AppColors.inputBackground,
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: controller.myGigs.map((dynamic gig) {
                        final title = gig['title'] ?? 'Pekerjaan';
                        final double priceVal = double.tryParse(gig['price']?.toString() ?? '0') ?? 0;
                        final String priceStr = 'Rp ${priceVal.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
                        return DropdownMenuItem<dynamic>(
                          value: gig,
                          child: Text(
                            '$title ($priceStr)',
                            style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        controller.selectGig(value);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }),

              // Info Laporan Card (Gig & User reported)
              Obx(() {
                if (controller.title.value.isEmpty && controller.helperName.value.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.title.value.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.work_outline, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pekerjaan yang Dilaporkan',
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.title.value,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (controller.title.value.isNotEmpty && controller.helperName.value.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3)),
                        ),
                      ],
                      if (controller.helperName.value.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_outline, size: 16, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pengguna yang Dilaporkan',
                                    style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.helperName.value,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }),

              // Dropdown Kategori Laporan
              const Text(
                'Kategori Laporan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: controller.selectedCategory.value,
                hint: const Text(
                  'Pilih kategori pelanggaran...',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
                decoration: InputDecoration(
                  fillColor: AppColors.inputBackground,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: controller.categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(
                      category,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.selectedCategory.value = value;
                },
              ),
              const SizedBox(height: 20),

              // Text Area Detail Kejadian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Detail Kejadian',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Obx(() => Text(
                    '${controller.charCount.value}/500',
                    style: TextStyle(
                      fontSize: 12,
                      color: controller.charCount.value > 450 ? Colors.red : AppColors.textSecondary,
                      fontWeight: controller.charCount.value > 450 ? FontWeight.bold : FontWeight.normal,
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.detailController,
                maxLines: 5,
                maxLength: 500,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => const SizedBox.shrink(),
                style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Jelaskan kronologis kejadian secara jelas dan objektif agar kami dapat memprosesnya...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  fillColor: AppColors.inputBackground,
                  filled: true,
                  contentPadding: const EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Upload Bukti Section
              const Text(
                'Unggah Bukti Kejadian',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              
              // Custom Dashed Upload Box
              GestureDetector(
                onTap: () => controller.addPhoto(),
                child: CustomPaint(
                  painter: DashedRectPainter(
                    color: Colors.red.shade200,
                    strokeWidth: 1.5,
                    gap: 6.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFBFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload_outlined, color: Colors.red.shade400, size: 36),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              text: 'Tap untuk unggah bukti foto ',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                TextSpan(
                                  text: '*Wajib',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Format: JPG, PNG (Maks. 3 foto, @5MB)',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Thumbnails of uploaded images
              Obx(() {
                if (controller.evidencePhotos.isEmpty) return const SizedBox.shrink();
                return Container(
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.evidencePhotos.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade100),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(controller.evidencePhotos[index].path),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Small red label for photo index
                          Positioned(
                            bottom: 4,
                            left: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Bukti ${index + 1}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // Remove button
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () => controller.removePhoto(index),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red.shade800,
                                child: const Icon(Icons.close, color: Colors.white, size: 10),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 48,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : () => controller.submitReport(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade800,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.red.shade800.withOpacity(0.6),
                      disabledForegroundColor: Colors.white.withOpacity(0.8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Kirim Laporan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for dashed rectangle
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedRectPainter({
    this.color = Colors.grey,
    this.strokeWidth = 1.5,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    const double radius = 16.0;
    
    // Add rounded rect to path
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(radius),
    ));

    // Draw dashed path
    final Path dashPath = Path();
    double distance = 0.0;
    
    for (PathMetric measurePath in path.computeMetrics()) {
      while (distance < measurePath.length) {
        dashPath.addPath(
          measurePath.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
