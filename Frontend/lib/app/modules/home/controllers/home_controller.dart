import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class HomeController extends GetxController {
  final hasActiveGig = false.obs;
  final activeGig = Rxn<Map<String, dynamic>>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchActiveGig();
  }

  Future<void> fetchActiveGig() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getRequest('/gigs', query: {
        'status': 'in_progress',
        'my_jobs': '1',
      });

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success' && body['data'] != null) {
          final list = body['data'] as List;
          if (list.isNotEmpty) {
            activeGig.value = Map<String, dynamic>.from(list.first);
            hasActiveGig.value = true;
            return;
          }
        }
      }
      activeGig.value = null;
      hasActiveGig.value = false;
    } catch (e) {
      debugPrint("Gagal mengambil data gig aktif: $e");
      activeGig.value = null;
      hasActiveGig.value = false;
    } finally {
      isLoading.value = false;
    }
  }
}
