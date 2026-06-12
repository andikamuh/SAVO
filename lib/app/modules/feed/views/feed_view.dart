import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/feed_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class FeedView extends GetView<FeedController> {
  const FeedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Obx(() {
                        final avatar = Get.find<ProfileController>().avatarUrl.value;
                        return Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primaryDark.withOpacity(0.2), width: 1.5),
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: AppColors.inputBackground,
                            backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                            child: avatar.isEmpty
                                ? const Icon(Icons.person, color: AppColors.textSecondary, size: 20)
                                : null,
                          ),
                        );
                      }),
                      const SizedBox(width: 12),
                      const Text(
                        'SAVO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none, color: AppColors.primaryDark, size: 28),
                    onPressed: () => Get.toNamed(Routes.NOTIFICATIONS),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.inputBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  onChanged: (val) => controller.searchQuery.value = val,
                  decoration: InputDecoration(
                    hintText: 'Search for gigs...',
                    hintStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Categories
            SizedBox(
              height: 40,
              child: Obx(() => ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildCategoryChip('Semua', Icons.grid_view, controller.selectedCategory.value == 'Semua'),
                  _buildCategoryChip('Tugas Kuliah', Icons.school, controller.selectedCategory.value == 'Tugas Kuliah'),
                  _buildCategoryChip('Desain', Icons.design_services, controller.selectedCategory.value == 'Desain'),
                  _buildCategoryChip('Antar Barang', Icons.local_shipping, controller.selectedCategory.value == 'Antar Barang'),
                  _buildCategoryChip('Lainnya', Icons.more_horiz, controller.selectedCategory.value == 'Lainnya'),
                ],
              )),
            ),
            const SizedBox(height: 16),
            // Gig List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryDark));
                }
                // Force GetX to register reactive dependency on filter changes
                final _ = controller.selectedCategory.value;
                final __ = controller.searchQuery.value;
                
                final list = controller.filteredGigs;
                if (list.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada gig saat ini.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  );
                }
                return RefreshIndicator(
                  color: AppColors.primaryDark,
                  onRefresh: () => controller.fetchGigs(),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final gig = list[index];
                      final int gigId = gig['id'] ?? 0;
                      final String title = gig['title'] ?? '';
                      final String description = gig['description'] ?? '';
                      final String location = gig['location'] ?? '';
                      final String category = gig['category'] ?? 'Tugas Kuliah';
                      
                      final double priceVal = (gig['price'] is num) 
                          ? (gig['price'] as num).toDouble() 
                          : double.tryParse(gig['price']?.toString() ?? '0') ?? 0;
                      final String price = 'Rp ${priceVal.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
                      
                      final String posterName = gig['requester'] != null 
                          ? (gig['requester']['name'] ?? 'Anonim') 
                          : 'Anonim';
                      
                      final String posterAvatar = gig['requester'] != null 
                          ? (gig['requester']['avatar_url'] ?? '') 
                          : '';
                      
                      final String deadlineDateRaw = gig['deadline_date'] ?? '';
                      String deadlineDate = deadlineDateRaw;
                      if (deadlineDate.contains('T')) {
                        deadlineDate = deadlineDate.split('T')[0];
                      }
                      
                      final String deadlineTimeRaw = gig['deadline_time'] ?? '';
                      String deadlineTime = deadlineTimeRaw;
                      if (deadlineTime.length > 5) {
                        deadlineTime = deadlineTime.substring(0, 5);
                      }
                      
                      final String time = '$deadlineDate, $deadlineTime';
                      
                      IconData tagIcon = Icons.school;
                      Color tagColor = AppColors.primaryDark;
                      Color tagTextColor = AppColors.white;
                      
                      if (category == 'Desain') {
                        tagIcon = Icons.design_services;
                        tagColor = Colors.red.shade50;
                        tagTextColor = Colors.red.shade900;
                      } else if (category == 'Antar Barang') {
                        tagIcon = Icons.local_shipping;
                        tagColor = Colors.blue.shade50;
                        tagTextColor = Colors.blue.shade900;
                      } else if (category == 'Lainnya') {
                        tagIcon = Icons.more_horiz;
                        tagColor = Colors.grey.shade200;
                        tagTextColor = Colors.grey.shade800;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildGigCard(
                          gigId: gigId,
                          tag: category,
                          tagColor: tagColor,
                          tagTextColor: tagTextColor,
                          tagIcon: tagIcon,
                          price: price,
                          location: location,
                          title: title,
                          description: description,
                          posterName: posterName,
                          time: time,
                          timeColor: Colors.red,
                          posterAvatar: posterAvatar,
                        ),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setCategory(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGigCard({
    required int gigId,
    required String tag,
    required Color tagColor,
    required Color tagTextColor,
    required IconData tagIcon,
    required String price,
    required String location,
    required String title,
    required String description,
    required String posterName,
    required String time,
    required Color timeColor,
    required String posterAvatar,
  }) {
    final cardArgs = {
      'id': gigId,
      'title': title,
      'price': price,
      'tag': tag,
      'time': time,
      'location': location,
      'posterName': posterName,
      'description': description,
      'posterAvatar': posterAvatar,
    };

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.DETAIL_GIG, arguments: cardArgs),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(tagIcon, size: 10, color: tagTextColor),
                      const SizedBox(width: 4),
                      Text(
                        tag,
                        style: TextStyle(fontSize: 10, color: tagTextColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: posterAvatar.isNotEmpty 
                            ? NetworkImage(posterAvatar) 
                            : null,
                        child: posterAvatar.isEmpty 
                            ? const Icon(Icons.person, size: 20, color: Colors.white) 
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              posterName,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Row(
                              children: [
                                Icon(Icons.access_time, size: 12, color: timeColor),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    time,
                                    style: TextStyle(fontSize: 10, color: timeColor, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.DETAIL_GIG, arguments: cardArgs),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade900,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Ambil Gig', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
