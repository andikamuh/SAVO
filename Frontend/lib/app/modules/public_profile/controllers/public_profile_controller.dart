import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class PublicProfileController extends GetxController {
  final isLoading = true.obs;
  final id = 0.obs;
  final name = ''.obs;
  final bio = ''.obs;
  final avatarUrl = ''.obs;
  final universitas = ''.obs;
  final prodi = ''.obs;
  final rating = '5.0'.obs;
  final ratingCount = 0.obs;
  final gigs = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    int fetchId = 0;
    if (args != null) {
      if (args is Map && args['partnerId'] != null) {
        fetchId = args['partnerId'] as int;
      } else if (args is int) {
        fetchId = args;
      }
    }
    if (fetchId == 0) {
      final paramId = Get.parameters['id'];
      if (paramId != null) {
        fetchId = int.tryParse(paramId) ?? 0;
      }
    }

    if (fetchId != 0) {
      fetchPublicProfile(fetchId);
    } else {
      isLoading.value = false;
      Get.snackbar('Error', 'User ID tidak valid.', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> fetchPublicProfile(int userId) async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getRequest('/users/$userId/public-profile');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        final data = body['data'] as Map<String, dynamic>?;
        if (data != null) {
          id.value = data['id'] as int? ?? 0;
          name.value = data['name'] as String? ?? '';
          bio.value = data['bio'] as String? ?? 'Belum ada bio.';
          avatarUrl.value = data['avatar_url'] as String? ?? '';
          universitas.value = data['universitas'] as String? ?? '';
          prodi.value = data['prodi'] as String? ?? '';
          rating.value = data['rating']?.toString() ?? '5.0';
          ratingCount.value = data['rating_count'] as int? ?? 0;
          gigs.assignAll(data['gigs'] as List? ?? []);
        }
      } else {
        Get.snackbar('Gagal', 'Gagal memuat profil pengguna.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi bermasalah: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
