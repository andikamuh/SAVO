import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/api_service.dart';
import '../../profile/controllers/profile_controller.dart';

class ReportController extends GetxController {
  final gigId = "".obs;
  final title = "".obs;
  final helperName = "".obs;

  final myGigs = <dynamic>[].obs;
  final selectedGig = Rxn<dynamic>();
  final isLoadingGigs = false.obs;

  final categories = [
    "Pekerjaan tidak sesuai deskripsi",
    "Helper tidak dapat dihubungi",
    "Permintaan pembayaran tambahan di luar aplikasi",
    "Perilaku tidak sopan atau kasar",
    "Penipuan atau kecurangan",
    "Lainnya"
  ];
  
  final selectedCategory = RxnString();
  final charCount = 0.obs;
  final evidencePhotos = <XFile>[].obs; // holds list of real picked image files
  final isLoading = false.obs;
  
  late TextEditingController detailController;
  final _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    detailController = TextEditingController();
    
    // Listen to text change for character counting
    detailController.addListener(() {
      charCount.value = detailController.text.length;
    });

    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args['gigId'] != null) gigId.value = args['gigId'].toString();
      if (args['title'] != null) title.value = args['title'];
      if (args['helperName'] != null) helperName.value = args['helperName'];
    }

    if (gigId.value.isEmpty) {
      fetchMyGigs();
    }
  }

  Future<void> fetchMyGigs() async {
    isLoadingGigs.value = true;
    try {
      final response = await ApiService.to.getRequest('/gigs', query: {'involved': '1'});
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          myGigs.value = body['data'] as List<dynamic>? ?? [];
        }
      }
    } catch (e) {
      debugPrint("Gagal mengambil data gig saya: $e");
    } finally {
      isLoadingGigs.value = false;
    }
  }

  void selectGig(dynamic gig) {
    if (gig == null) return;
    selectedGig.value = gig;
    gigId.value = gig['id']?.toString() ?? "";
    title.value = gig['title'] ?? "";
    
    final myId = Get.find<ProfileController>().id.value;
    final requesterId = gig['user_id'] as int? ?? 0;
    
    if (myId == requesterId) {
      final helper = gig['helper'] as Map<String, dynamic>?;
      helperName.value = helper?['name'] ?? "Helper";
    } else {
      final requester = gig['requester'] as Map<String, dynamic>?;
      helperName.value = requester?['name'] ?? "Peminta Jasa";
    }
  }

  @override
  void onClose() {
    // Note: To avoid text controller dispose crash during page transitions in GetX,
    // we let the GC manage disposes on text controllers inside views.
    super.onClose();
  }

  void addPhoto() async {
    if (evidencePhotos.length >= 3) {
      Get.snackbar(
        "Peringatan",
        "Maksimal 3 foto bukti saja.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      
      if (pickedFile != null) {
        evidencePhotos.add(pickedFile);
        Get.snackbar(
          "Berhasil",
          "Bukti foto ke-${evidencePhotos.length} berhasil diunggah!",
          backgroundColor: const Color(0xFF190000),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal memilih foto bukti.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < evidencePhotos.length) {
      evidencePhotos.removeAt(index);
    }
  }

  Future<void> submitReport() async {
    if (isLoading.value) return;

    if (selectedCategory.value == null) {
      Get.snackbar(
        "Peringatan",
        "Harap pilih kategori laporan terlebih dahulu.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (detailController.text.trim().isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Harap isi detail kejadian secara lengkap.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (evidencePhotos.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Unggah bukti foto wajib diisi.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Build form fields
      final Map<String, dynamic> fields = {
        'gig_id': gigId.value,
        'category': selectedCategory.value!,
        'detail_text': detailController.text,
      };

      // Add each evidence file as MultipartFile using readAsBytesSync
      for (int i = 0; i < evidencePhotos.length; i++) {
        final file = File(evidencePhotos[i].path);
        fields['evidences[$i]'] = MultipartFile(
          file.readAsBytesSync(),
          filename: 'evidence_$i.jpg',
        );
      }

      final form = FormData(fields);
      final response = await ApiService.to.postRequest('/reports', form);

      if (response.statusCode == 201 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          Get.snackbar(
            "Laporan Terkirim",
            "Laporan Anda sedang diproses oleh admin SAVO. Kami akan segera menindaklanjuti.",
            backgroundColor: Colors.red.shade900,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
          );

          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
          });
          return;
        }
      }

      final errorMsg = (response.body != null && response.body is Map)
          ? response.body['message'] ?? 'Gagal mengirimkan laporan'
          : 'Gagal terhubung ke server';

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
        "Terjadi kesalahan koneksi saat mengirim laporan",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
