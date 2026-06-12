import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/detail_gig_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class DetailGigView extends GetView<DetailGigController> {
  const DetailGigView({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Profile Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _buildCardDecoration(),
                child: Row(
                  children: [
                    Stack(
                      children: [
                    Obx(() => CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: controller.posterAvatar.value.isNotEmpty
                          ? NetworkImage(controller.posterAvatar.value)
                          : const NetworkImage('https://cdn-uploads.owlink.id/contenful/game-java/jawa_character.png'),
                      child: controller.posterAvatar.value.isEmpty
                          ? const Icon(Icons.person, color: Colors.white, size: 28)
                          : null,
                    )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            controller.posterName.value,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          )),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.orange, size: 12),
                                    const SizedBox(width: 2),
                                    Obx(() => Text(
                                      controller.posterRating.value,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red.shade900,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•   Peminta Jasa',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Gig Info Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
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
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.red.shade50.withOpacity(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.school, size: 12, color: Colors.red.shade900),
                              const SizedBox(width: 4),
                              Obx(() => Text(
                                controller.tag.value,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade900,
                                ),
                              )),
                            ],
                          ),
                        ),
                        Obx(() => Text(
                          controller.price.value,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        )),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Text(
                      controller.title.value,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    )),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 6),
                          Obx(() => Text(
                            'Tenggat: ${controller.time.value}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Deskripsi Pekerjaan Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description_outlined, color: AppColors.textPrimary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Deskripsi Pekerjaan',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                      controller.description.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Lokasi Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: _buildCardDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, color: AppColors.textPrimary, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Lokasi',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Obx(() => Text(
                      controller.location.value,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Spacing for floating buttons
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final profileCtrl = Get.find<ProfileController>();
        final myId = profileCtrl.id.value;
        final isOwner = controller.userId.value == myId;
        final status = controller.gigStatus.value;
        final helperId = controller.helperId.value;

        // Button action & text logic
        String actionText = 'Ambil Pekerjaan';
        VoidCallback? actionPressed;
        bool isActionEnabled = true;

        if (isOwner) {
          isActionEnabled = false;
          if (status == 'open') {
            actionText = 'Menunggu Helper';
          } else if (status == 'in_progress') {
            actionText = 'Pekerjaan Berjalan';
          } else if (status == 'completed') {
            actionText = 'Pekerjaan Selesai';
          } else {
            actionText = 'Pekerjaan Anda';
          }
        } else {
          if (status == 'open') {
            actionText = 'Ambil Pekerjaan';
            actionPressed = () => Get.toNamed(Routes.KONFIRMASI_GIG, arguments: {
              'id': controller.gigId.value,
              'title': controller.title.value,
              'price': controller.price.value,
              'location': controller.location.value,
              'time': controller.time.value,
            });
          } else if (status == 'in_progress') {
            if (helperId == myId) {
              actionText = 'Selesaikan Pekerjaan';
              actionPressed = () => Get.toNamed(Routes.PENYELESAIAN_GIG, arguments: {
                'id': controller.gigId.value,
                'title': controller.title.value,
                'price': controller.price.value,
              });
            } else {
              actionText = 'Sedang Dikerjakan';
              isActionEnabled = false;
            }
          } else if (status == 'completed') {
            actionText = 'Pekerjaan Selesai';
            isActionEnabled = false;
          }
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Chat Button
              SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () => controller.startChat(),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.chat_bubble_outline, color: AppColors.textPrimary, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Chat',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Action Button
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isActionEnabled ? actionPressed : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isActionEnabled ? AppColors.primaryDark : Colors.grey.shade300,
                      foregroundColor: isActionEnabled ? Colors.white : Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: isActionEnabled ? 2 : 0,
                    ),
                    child: Text(
                      actionText,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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
