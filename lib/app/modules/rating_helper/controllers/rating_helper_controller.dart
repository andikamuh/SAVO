import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';

class RatingHelperController extends GetxController {
  final gigId = 0.obs;
  final revieweeId = 0.obs;
  final title = "Bantu ketik ulang makalah sejarah, 15 halaman".obs;
  final price = "Rp 50.000".obs;
  final category = "Desain".obs;
  final helperName = "Mas Amba".obs;
  final helperAvatar = "https://cdn-uploads.owlink.id/contenful/game-java/jawa_character.png".obs;

  final isConfirmed = false.obs;
  final isRequester = false.obs;
  final rating = 5.obs;
  
  late TextEditingController reviewController;

  @override
  void onInit() {
    super.onInit();
    reviewController = TextEditingController();
    
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['gigId'] != null) {
        gigId.value = args['gigId'] is int ? args['gigId'] : (int.tryParse(args['gigId'].toString()) ?? 0);
      }
      if (args['title'] != null) title.value = args['title'];
      if (args['price'] != null) price.value = args['price'];
      if (args['category'] != null) category.value = args['category'];
      if (args['helperName'] != null) helperName.value = args['helperName'];
      if (args['helperAvatar'] != null) helperAvatar.value = args['helperAvatar'];
    }
    fetchGigAndRevieweeDetails();
  }

  Future<void> fetchGigAndRevieweeDetails() async {
    if (gigId.value == 0) return;
    try {
      final response = await ApiService.to.getRequest('/gigs/${gigId.value}');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final gig = body['data'] as Map<String, dynamic>;
          final profileRes = await ApiService.to.getRequest('/profile');
          if (profileRes.statusCode == 200 && profileRes.body != null) {
            final profileBody = profileRes.body as Map<String, dynamic>;
            final profile = profileBody['data'] as Map<String, dynamic>;
            
            final int currentUserId = profile['id'] ?? 0;
            final int requesterId = gig['user_id'] ?? 0;
            final int helperIdVal = gig['helper_id'] ?? 0;
            
            if (currentUserId == requesterId) {
              isRequester.value = true;
              revieweeId.value = helperIdVal;
              if (gig['helper'] != null) {
                helperName.value = gig['helper']['name'] ?? 'Helper';
              }
            } else {
              isRequester.value = false;
              isConfirmed.value = true;
              revieweeId.value = requesterId;
              if (gig['requester'] != null) {
                helperName.value = gig['requester']['name'] ?? 'Peminta Jasa';
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching details for review: $e");
    }
  }

  @override
  void onClose() {
    reviewController.dispose();
    super.onClose();
  }

  Future<void> confirmDone() async {
    try {
      final response = await ApiService.to.postRequest('/gigs/${gigId.value}/confirm-release', {});
      if (response.statusCode == 200) {
        isConfirmed.value = true;
        Get.snackbar(
          "Berhasil",
          "Pembayaran berhasil dilepas dan pekerjaan dikonfirmasi selesai!",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        final errorMsg = (response.body != null && response.body is Map)
            ? response.body['message'] ?? 'Gagal melepaskan pembayaran'
            : 'Gagal melepaskan pembayaran';
        Get.snackbar(
          "Gagal",
          errorMsg,
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
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

  void complain() {
    Get.toNamed(Routes.REPORT, arguments: {
      'gigId': gigId.value,
      'title': title.value,
      'helperName': helperName.value,
    });
  }

  Future<void> submitReview() async {
    if (!isConfirmed.value) {
      Get.snackbar(
        "Peringatan",
        "Harap konfirmasi penyelesaian pekerjaan terlebih dahulu dengan menekan tombol 'Ya, Selesai'.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      final response = await ApiService.to.postRequest('/reviews', {
        'gig_id': gigId.value,
        'reviewee_id': revieweeId.value == 0 ? 1 : revieweeId.value, // Fallback to 1 if reviewee is undefined in static flow
        'rating': rating.value,
        'review_text': reviewController.text,
      });

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Reset active gig in HomeController
        try {
          if (Get.isRegistered<HomeController>()) {
            final homeController = Get.find<HomeController>();
            homeController.hasActiveGig.value = false;
            homeController.fetchActiveGig();
          }
          if (Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().fetchProfile();
          }
        } catch (e) {
          debugPrint("Error on review success updates: $e");
        }

        Get.snackbar(
          "Terima Kasih",
          "Ulasan Anda berhasil dikirim!",
          backgroundColor: const Color(0xFF190000),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        Future.delayed(const Duration(milliseconds: 1000), () {
          Get.offAllNamed(Routes.MAIN);
        });
        return;
      }

      final errorMsg = (response.body != null && response.body is Map)
          ? response.body['message'] ?? 'Gagal mengirim ulasan'
          : 'Gagal mengirim ulasan';

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
