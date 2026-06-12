import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/post_gig_controller.dart';

class PostGigView extends GetView<PostGigController> {
  const PostGigView({Key? key}) : super(key: key);

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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Post a Gig',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill out the details below to find the right student for the job.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // DETAIL PEKERJAAN Section
              _buildSectionLabel('DETAIL PEKERJAAN'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Judul Pekerjaan'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.judulController,
                      hintText: 'Contoh: Desain Logo untuk Startup',
                    ),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Deskripsi Lengkap'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.deskripsiController,
                      hintText: 'Jelaskan kebutuhan spesifik Anda secara detail...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Lokasi'),
                    const SizedBox(height: 8),
                    _buildTextField(
                      controller: controller.lokasiController,
                      hintText: 'Contoh: Gedung Cheng Ho, Universitas Mulia',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // TENGGAT WAKTU Section
              _buildSectionLabel('TENGGAT WAKTU'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectDate(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _buildCardDecoration(),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: AppColors.primaryDark, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TANGGAL',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    controller.tanggal.value,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.selectTime(context),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: _buildCardDecoration(),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time_outlined, color: AppColors.primaryDark, size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'WAKTU',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Obx(() => Text(
                                    controller.waktu.value,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // KATEGORI Section
              _buildSectionLabel('KATEGORI'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Pilih Kategori'),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedCategory.value == "Select Category"
                              ? null
                              : controller.selectedCategory.value,
                          hint: const Text(
                            "Select Category",
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                          items: controller.categories.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Text(category, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            if (newValue != null) {
                              controller.selectedCategory.value = newValue;
                            }
                          },
                        ),
                      )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // HARGA Section
              _buildSectionLabel('HARGA (IMBALAN)'),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Masukkan Harga (Custom)'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border.withOpacity(0.5)),
                      ),
                      child: TextField(
                        controller: controller.hargaController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          prefixText: 'Rp ',
                          prefixStyle: TextStyle(color: AppColors.primaryDark, fontSize: 15, fontWeight: FontWeight.bold),
                          hintText: 'Contoh: 150000',
                          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.normal),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFieldLabel('Pilihan Cepat'),
                    const SizedBox(height: 8),
                    Obx(() {
                      // Trigger reactive redraw of Chips when value in controller.hargaController changes
                      // To make sure ChoiceChips reflect reactive changes, we listen to a dummy obs or simply use controller.hargaController's content
                      // Let's create an elegant Wrap of choice chips
                      return Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.presetPrices.map((String rawPrice) {
                          final doubleVal = double.tryParse(rawPrice) ?? 0.0;
                          String formatted = rawPrice;
                          if (doubleVal >= 1000) {
                            final kVal = (doubleVal / 1000).toStringAsFixed(0);
                            formatted = "${kVal}rb";
                          }
                          
                          // Custom listener to see if active
                          final isSelected = controller.hargaTerpilih.value == rawPrice;
                          
                          return ChoiceChip(
                            label: Text(
                              "Rp $formatted",
                              style: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            selected: isSelected,
                            selectedColor: AppColors.primaryDark,
                            backgroundColor: AppColors.inputBackground,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            onSelected: (bool selected) {
                              if (selected) {
                                controller.hargaController.text = rawPrice;
                                // Force an UI update by calling dummy update if necessary, or since Obx is listening to reactive states, let's trigger it nicely
                              }
                            },
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Spacing for bottom button
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
          child: Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value ? null : () => controller.postGig(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
              disabledBackgroundColor: AppColors.primaryDark.withOpacity(0.6),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Posting Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                    ],
                  ),
          )),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: AppColors.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
