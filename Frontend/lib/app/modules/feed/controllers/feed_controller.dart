import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class FeedController extends GetxController {
  final allGigsList = <dynamic>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'Semua'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGigs();
  }

  Future<void> fetchGigs() async {
    isLoading.value = true;
    try {
      // Only request open status gigs for the feed
      final response = await ApiService.to.getRequest('/gigs', query: {'status': 'open'});
      
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          allGigsList.value = body['data'] as List<dynamic>;
        }
      }
    } catch (e) {
      Get.snackbar('Koneksi Gagal', 'Gagal memuat list gig dari server.');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  List<dynamic> get filteredGigs {
    return allGigsList.where((gig) {
      // 1. Category Filter
      if (selectedCategory.value != 'Semua' && gig['category'] != selectedCategory.value) {
        return false;
      }
      // 2. Search Query Filter
      if (searchQuery.value.trim().isNotEmpty) {
        final title = (gig['title'] ?? '').toString().toLowerCase();
        final description = (gig['description'] ?? '').toString().toLowerCase();
        final location = (gig['location'] ?? '').toString().toLowerCase();
        final query = searchQuery.value.toLowerCase();
        return title.contains(query) || description.contains(query) || location.contains(query);
      }
      return true;
    }).toList();
  }
}
