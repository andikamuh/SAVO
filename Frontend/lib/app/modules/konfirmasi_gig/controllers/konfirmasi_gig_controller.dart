import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../feed/controllers/feed_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';

class KonfirmasiGigController extends GetxController {
  final isAgreed = false.obs;
  final gigId = 0.obs;

  final title = "Bantu ketik ulang Makalah sejarah, 15 halaman".obs;
  final price = "Rp 50.000".obs;
  final location = "Kantin Universitas Mulia".obs;
  final time = "Besok, 12:00".obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['id'] != null) {
        gigId.value = args['id'] is int ? args['id'] : (int.tryParse(args['id'].toString()) ?? 0);
      }
      if (args['title'] != null) title.value = args['title'];
      if (args['price'] != null) price.value = args['price'];
      if (args['location'] != null) location.value = args['location'];
      if (args['time'] != null) time.value = args['time'];
    }
  }

  Future<void> ambilPekerjaan() async {
    if (!isAgreed.value) return;

    try {
      final response = await ApiService.to.postRequest('/gigs/${gigId.value}/accept', {});
      
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          // Set active gig in HomeController to reflect in main dashboard
          try {
            if (Get.isRegistered<HomeController>()) {
              final homeController = Get.find<HomeController>();
              homeController.fetchActiveGig();
            }
            if (Get.isRegistered<FeedController>()) {
              Get.find<FeedController>().fetchGigs();
            }
          } catch (e) {
            debugPrint("HomeController or FeedController not registered: $e");
          }

          Get.snackbar(
            "Sukses",
            "Pekerjaan berhasil diambil!",
            backgroundColor: const Color(0xFF190000),
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          // Direct to Penyelesaian Screen
          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offNamed(Routes.PENYELESAIAN_GIG, arguments: {
              'id': gigId.value,
              'title': title.value,
              'price': price.value,
            });
          });
          return;
        }
      }
      
      final errorMsg = (response.body != null && response.body is Map)
          ? response.body['message'] ?? 'Gagal mengambil pekerjaan'
          : 'Gagal mengambil pekerjaan';
      
      Get.snackbar(
        "Gagal",
        errorMsg,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan koneksi",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
