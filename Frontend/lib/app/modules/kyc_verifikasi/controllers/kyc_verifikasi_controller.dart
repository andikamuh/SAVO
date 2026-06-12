import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/services/api_service.dart';
import '../../../routes/app_pages.dart';
import '../views/custom_camera_screen.dart';

class KycVerifikasiController extends GetxController {
  final ktmImage = Rxn<File>();
  final selfieImage = Rxn<File>();
  final isUploading = false.obs;

  final _picker = ImagePicker();

  bool get hasKtm => ktmImage.value != null;
  bool get hasSelfie => selfieImage.value != null;

  @override
  void onInit() {
    super.onInit();
    
    // Restore persistent paths if they exist and files are valid
    final savedKtm = ApiService.to.ktmImagePath;
    if (savedKtm != null && File(savedKtm).existsSync()) {
      ktmImage.value = File(savedKtm);
    }
    final savedSelfie = ApiService.to.selfieImagePath;
    if (savedSelfie != null && File(savedSelfie).existsSync()) {
      selfieImage.value = File(savedSelfie);
    }

    _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    try {
      final LostDataResponse response = await _picker.retrieveLostData();
      if (response.isEmpty) return;
      if (response.file != null) {
        final type = ApiService.to.lastPickType;
        final appDir = await getApplicationDocumentsDirectory();
        if (type == 'ktm') {
          final savedFile = await File(response.file!.path).copy('${appDir.path}/ktm_temp.jpg');
          await ApiService.to.setKtmImagePath(savedFile.path);
          ktmImage.value = savedFile;
          Get.snackbar(
            'Sukses',
            'Kartu Tanda Mahasiswa (KTM) berhasil dipulihkan.',
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else if (type == 'selfie') {
          final savedFile = await File(response.file!.path).copy('${appDir.path}/selfie_temp.jpg');
          await ApiService.to.setSelfieImagePath(savedFile.path);
          selfieImage.value = savedFile;
          Get.snackbar(
            'Sukses',
            'Foto Selfie berhasil dipulihkan.',
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      debugPrint("Gagal memulihkan foto: $e");
    }
  }

  void pickKtm(ImageSource source) async {
    try {
      await ApiService.to.setLastPickType('ktm');
      
      File? pickedFile;
      if (source == ImageSource.camera) {
        pickedFile = await Get.to<File>(() => const CustomCameraScreen(
          isFrontCamera: false,
          overlayType: CameraOverlayType.ktm,
        ));
      } else {
        final XFile? xFile = await _picker.pickImage(
          source: source,
          maxWidth: 1024, // Optimized resolution to stay under 2MB
          maxHeight: 1024,
          imageQuality: 85,
        );
        if (xFile != null) {
          pickedFile = File(xFile.path);
        }
      }

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final savedFile = await pickedFile.copy('${appDir.path}/ktm_temp.jpg');
        await ApiService.to.setKtmImagePath(savedFile.path);
        ktmImage.value = savedFile;
        Get.snackbar(
          'Sukses',
          'Kartu Tanda Mahasiswa (KTM) berhasil dipilih.',
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal memilih gambar KTM: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void pickSelfie(ImageSource source) async {
    try {
      await ApiService.to.setLastPickType('selfie');

      File? pickedFile;
      if (source == ImageSource.camera) {
        pickedFile = await Get.to<File>(() => const CustomCameraScreen(
          isFrontCamera: true,
          overlayType: CameraOverlayType.face,
        ));
      } else {
        final XFile? xFile = await _picker.pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
          preferredCameraDevice: CameraDevice.front,
        );
        if (xFile != null) {
          pickedFile = File(xFile.path);
        }
      }

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final savedFile = await pickedFile.copy('${appDir.path}/selfie_temp.jpg');
        await ApiService.to.setSelfieImagePath(savedFile.path);
        selfieImage.value = savedFile;
        Get.snackbar(
          'Sukses',
          'Foto Selfie berhasil diambil.',
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto selfie: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Show bottom sheet to choose between Camera and Gallery
  void showImageSourceSelection({required bool isKtm}) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              isKtm ? 'Pilih Metode Unggah KTM' : 'Pilih Metode Verifikasi Wajah',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: 'Kamera',
                  onTap: () {
                    Get.back();
                    if (isKtm) {
                      pickKtm(ImageSource.camera);
                    } else {
                      pickSelfie(ImageSource.camera);
                    }
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: 'Galeri',
                  onTap: () {
                    Get.back();
                    if (isKtm) {
                      pickKtm(ImageSource.gallery);
                    } else {
                      pickSelfie(ImageSource.gallery);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1EC8C8).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> submitKyc() async {
    if (!hasKtm || !hasSelfie) {
      Get.snackbar(
        'Dokumen Belum Lengkap',
        'Harap lengkapi unggahan KTM dan Verifikasi Wajah terlebih dahulu.',
        backgroundColor: Colors.amber.shade50,
        colorText: Colors.amber.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!ktmImage.value!.existsSync() || !selfieImage.value!.existsSync()) {
      Get.snackbar(
        'Gagal Membaca File',
        'Berkas foto tidak ditemukan atau terhapus oleh sistem. Silakan ambil ulang foto KTM dan Selfie.',
        backgroundColor: Colors.amber.shade50,
        colorText: Colors.amber.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      // Reset UI observables and clear invalid paths
      if (!ktmImage.value!.existsSync()) ktmImage.value = null;
      if (!selfieImage.value!.existsSync()) selfieImage.value = null;
      await ApiService.to.clearKycPaths();
      return;
    }

    isUploading.value = true;
    try {
      final form = FormData({
        'kyc_selfie': MultipartFile(selfieImage.value!.readAsBytesSync(), filename: 'selfie.jpg'),
        'kyc_ktm': MultipartFile(ktmImage.value!.readAsBytesSync(), filename: 'ktm.jpg'),
      });

      final response = await ApiService.to.postRequest('/profile/kyc', form);

      if ((response.statusCode == 200 || response.statusCode == 202) && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          // Clear saved paths
          await ApiService.to.clearKycPaths();
          
          // Delete local cached files
          try {
            if (ktmImage.value != null && ktmImage.value!.existsSync()) {
              ktmImage.value!.deleteSync();
            }
            if (selfieImage.value != null && selfieImage.value!.existsSync()) {
              selfieImage.value!.deleteSync();
            }
          } catch (e) {
            debugPrint("Gagal menghapus file KYC sementara: $e");
          }

          Get.snackbar(
            'Sukses',
            'Dokumen KYC berhasil diajukan untuk verifikasi!',
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade900,
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offAllNamed(Routes.KYC_PENDING);
          return;
        }
      }

      final errorMsg = (response.body != null && response.body is Map)
          ? response.body['message'] ?? 'Gagal mengajukan verifikasi KYC'
          : 'Gagal mengajukan verifikasi KYC';

      Get.snackbar(
        'Gagal KYC',
        errorMsg,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Gagal KYC',
        'Terjadi kesalahan koneksi: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
