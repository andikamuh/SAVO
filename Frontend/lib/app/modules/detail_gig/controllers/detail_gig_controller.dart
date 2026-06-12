import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../../profile/controllers/profile_controller.dart';

class DetailGigController extends GetxController {
  final gigId = 0.obs;
  final title = "Bantu ketik ulang makalah sejarah, 15 halaman".obs;
  final price = "Rp 50.000".obs;
  final tag = "Tugas Kuliah".obs;
  final time = "Besok, 12:00".obs;
  final location = "Kantin Universitas Mulia".obs;
  final posterName = "Budi Santoso".obs;
  final posterRating = "4.9".obs;
  final description =
      "Tolong bantu ketik ulang makalah sejarah dari file PDF ke format Word. Total 15 halaman, harus rapi dan sesuai format kampus. Referensi sudah tersedia."
          .obs;
  final posterAvatar = "".obs;

  final isLoadingChat = false.obs;

  final userId = 0.obs;
  final helperId = 0.obs;
  final gigStatus = "".obs;
  final isLoadingDetails = false.obs;

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
      if (args['tag'] != null) tag.value = args['tag'];
      if (args['time'] != null) time.value = args['time'];
      if (args['location'] != null) location.value = args['location'];
      if (args['posterName'] != null) posterName.value = args['posterName'];
      if (args['description'] != null) description.value = args['description'];
      if (args['posterAvatar'] != null) posterAvatar.value = args['posterAvatar'];
    }
    fetchGigDetails();
  }

  Future<void> fetchGigDetails() async {
    if (gigId.value == 0) return;
    isLoadingDetails.value = true;
    try {
      final response = await ApiService.to.getRequest('/gigs/${gigId.value}');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final data = body['data'] as Map<String, dynamic>;
          userId.value = data['user_id'] is int ? data['user_id'] : (int.tryParse(data['user_id'].toString()) ?? 0);
          helperId.value = data['helper_id'] is int 
              ? data['helper_id'] 
              : (data['helper_id'] != null ? (int.tryParse(data['helper_id'].toString()) ?? 0) : 0);
          gigStatus.value = data['status'] ?? "";
          
          if (data['title'] != null) title.value = data['title'];
          if (data['description'] != null) description.value = data['description'];
          if (data['location'] != null) location.value = data['location'];
          if (data['category'] != null) tag.value = data['category'];
          
          final double priceVal = (data['price'] is num) 
              ? (data['price'] as num).toDouble() 
              : double.tryParse(data['price']?.toString() ?? '0') ?? 0;
          price.value = 'Rp ${priceVal.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]}.")}';
          
          if (data['requester'] != null) {
            posterName.value = data['requester']['name'] ?? 'Anonim';
            posterAvatar.value = data['requester']['avatar_url'] ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat detail gig: $e");
    } finally {
      isLoadingDetails.value = false;
    }
  }

  Future<void> startChat() async {
    if (isLoadingChat.value) return;
    isLoadingChat.value = true;
    
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
      barrierDismissible: false,
    );

    try {
      final response = await ApiService.to.postRequest('/chats/get-or-create', {
        'gig_id': gigId.value,
      });

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final roomData = body['data'] as Map<String, dynamic>;
          final roomId = roomData['id'] as int;
          final requesterId = roomData['requester_id'] as int;
          final helperId = roomData['helper_id'] as int? ?? 0;
          
          final myId = Get.find<ProfileController>().id.value;
          final partnerId = myId == requesterId ? helperId : requesterId;

          Get.toNamed(Routes.CHAT_ROOM, arguments: {
            'roomId': roomId,
            'currentUserId': myId,
            'partnerId': partnerId,
            'posterName': posterName.value,
            'posterAvatar': posterAvatar.value,
            'title': title.value,
            'price': price.value,
          });
          return;
        }
      }
      
      String errorMessage = 'Gagal membuka obrolan. Silakan coba beberapa saat lagi.';
      if (response.body != null) {
        if (response.body is Map) {
          final body = response.body as Map;
          if (body['message'] != null) {
            errorMessage = body['message'].toString();
          }
        } else {
          try {
            final decoded = jsonDecode(response.bodyString ?? '');
            if (decoded is Map && decoded['message'] != null) {
              errorMessage = decoded['message'].toString();
            }
          } catch (_) {}
        }
      }

      Get.snackbar(
        'Gagal',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      Get.snackbar(
        'Error',
        'Koneksi bermasalah: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoadingChat.value = false;
    }
  }
}
