import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../kyc_verifikasi/views/custom_camera_screen.dart';

class EditProfileController extends GetxController {
  late ProfileController profileController;

  late TextEditingController nameController;
  late TextEditingController prodiController;
  late TextEditingController bioController;
  late TextEditingController accountController;

  final selectedBank = 'GoPay'.obs;
  final bankOptions = ['GoPay', 'OVO', 'DANA', 'LinkAja', 'Bank Mandiri', 'Bank BCA', 'Bank BRI'];

  final avatarBytes = Rxn<Uint8List>();
  final isAvatarChanged = false.obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    profileController = Get.find<ProfileController>();

    nameController = TextEditingController(text: profileController.nama.value);
    prodiController = TextEditingController(text: profileController.prodi.value);
    bioController = TextEditingController(text: profileController.bio.value);
    accountController = TextEditingController(text: profileController.bankAccount.value);
    
    if (bankOptions.contains(profileController.bankName.value)) {
      selectedBank.value = profileController.bankName.value;
    } else {
      selectedBank.value = bankOptions.first;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    prodiController.dispose();
    bioController.dispose();
    accountController.dispose();
    super.onClose();
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickAvatar(ImageSource source) async {
    try {
      File? pickedFile;
      if (source == ImageSource.camera) {
        pickedFile = await Get.to<File>(() => const CustomCameraScreen(
          isFrontCamera: true,
          overlayType: CameraOverlayType.none,
        ));
      } else {
        final XFile? file = await _picker.pickImage(
          source: source,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 85,
        );
        if (file != null) {
          pickedFile = File(file.path);
        }
      }

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        avatarBytes.value = bytes;
        isAvatarChanged.value = true;
        Get.snackbar(
          'Foto Terpilih',
          'Foto profil baru berhasil dipilih!',
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade900,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal mengambil foto profil: $e',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectNewAvatar() {
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
                "Pilih Foto Profil",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF190000)),
              title: const Text("Kamera (Ambil Foto Langsung)"),
              onTap: () {
                Get.back();
                pickAvatar(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF190000)),
              title: const Text("Galeri (Pilih dari Galeri)"),
              onTap: () {
                Get.back();
                pickAvatar(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    if (isLoading.value) return;
    
    final namaText = nameController.text.trim();
    final prodiText = prodiController.text.trim();
    
    if (namaText.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Nama lengkap tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    if (prodiText.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Program studi tidak boleh kosong.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    try {
      isLoading.value = true;
      final success = await profileController.updateProfile(
        newNama: namaText,
        newProdi: prodiText,
        newBio: bioController.text.trim(),
        newBankName: selectedBank.value,
        newBankAccount: accountController.text.trim(),
        newAvatarBytes: isAvatarChanged.value ? avatarBytes.value : null,
      );

      if (success) {
        Get.back();
        Get.snackbar(
          'Sukses',
          'Perubahan profil berhasil disimpan!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Terjadi kesalahan saat menyimpan perubahan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghubungi server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
