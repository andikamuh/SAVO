import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../data/services/api_service.dart';
import '../../kyc_verifikasi/views/custom_camera_screen.dart';

class PenyelesaianController extends GetxController {
  final gigId = 0.obs;
  final title = "Bantu ketik ulang Makalah sejarah, 15 halaman".obs;
  final price = "Rp 50.000".obs;
  final category = "Umum".obs;

  final requesterName = "Peminta Jasa".obs;
  final requesterAvatar = "https://cdn-uploads.owlink.id/contenful/game-java/jawa_character.png".obs;

  final photoUploaded = false.obs;
  final isTandaiSelesai = false.obs;

  final ImagePicker _picker = ImagePicker();
  final Rxn<XFile> evidenceImage = Rxn<XFile>();

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
    }
    fetchGigDetails();
  }

  Future<void> fetchGigDetails() async {
    if (gigId.value == 0) return;
    try {
      final response = await ApiService.to.getRequest('/gigs/${gigId.value}');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final gig = body['data'] as Map<String, dynamic>;
          category.value = gig['category'] ?? 'Umum';
          if (gig['requester'] != null) {
            requesterName.value = gig['requester']['name'] ?? 'Peminta Jasa';
            if (gig['requester']['avatar_url'] != null) {
              requesterAvatar.value = gig['requester']['avatar_url'];
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching gig details: $e");
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      XFile? image;
      if (source == ImageSource.camera) {
        final dynamic capturedFile = await Get.to(() => const CustomCameraScreen(
          isFrontCamera: false,
          overlayType: CameraOverlayType.none,
        ));
        if (capturedFile != null && capturedFile is File) {
          image = XFile(capturedFile.path);
        }
      } else {
        image = await _picker.pickImage(
          source: source,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );
      }

      if (image != null) {
        evidenceImage.value = image;
        photoUploaded.value = true;
        Get.snackbar(
          "Berhasil",
          "Bukti foto berhasil dipilih!",
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Gagal mengambil gambar: $e",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void uploadPhoto() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Wrap(
          children: [
            const ListTile(
              title: Text(
                "Pilih Sumber Foto Bukti",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF190000)),
              title: const Text("Kamera (Ambil Foto Langsung)"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF190000)),
              title: const Text("Galeri (Pilih dari Galeri)"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void markDone() {
    if (!photoUploaded.value || evidenceImage.value == null) {
      Get.snackbar(
        "Peringatan",
        "Harap unggah bukti foto terlebih dahulu",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    isTandaiSelesai.value = true;
    Get.snackbar(
      "Berhasil",
      "Tugas ditandai selesai! Anda dapat menekan tombol Selesai di bawah.",
      backgroundColor: Colors.green.shade100,
      colorText: Colors.green.shade900,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> finish() async {
    if (!isTandaiSelesai.value || evidenceImage.value == null) return;

    try {
      final bytes = await evidenceImage.value!.readAsBytes();
      final form = FormData({
        'photo': MultipartFile(bytes, filename: 'evidence.jpg'),
      });

      final response = await ApiService.to.postRequest('/gigs/${gigId.value}/complete', form);

      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          // Clear active gig in HomeController since it's now completed
          try {
            if (Get.isRegistered<HomeController>()) {
              final homeController = Get.find<HomeController>();
              homeController.hasActiveGig.value = false;
              homeController.fetchActiveGig();
            }
          } catch (e) {
            debugPrint("HomeController not registered: $e");
          }

          Get.snackbar(
            "Sukses",
            "Pekerjaan ditandai selesai!",
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade900,
            snackPosition: SnackPosition.BOTTOM,
          );

          Future.delayed(const Duration(milliseconds: 800), () {
            Get.offNamed(Routes.RATING_HELPER, arguments: {
              'gigId': gigId.value,
              'title': title.value,
              'price': price.value,
              'category': category.value,
              'helperName': requesterName.value,
              'helperAvatar': requesterAvatar.value,
            });
          });
          return;
        }
      }

      final errorMsg = (response.body != null && response.body is Map)
          ? response.body['message'] ?? 'Gagal menyelesaikan pekerjaan'
          : 'Gagal menyelesaikan pekerjaan';

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
