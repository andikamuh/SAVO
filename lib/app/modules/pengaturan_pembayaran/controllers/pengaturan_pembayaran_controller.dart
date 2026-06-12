import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';

class PengaturanPembayaranController extends GetxController {
  final isBankEnabled = false.obs;
  final isWalletEnabled = false.obs;
  final isCashEnabled = false.obs;

  final banks = ["BCA", "Mandiri", "BNI", "BRI", "CIMB Niaga"];
  final wallets = ["GoPay", "OVO", "Dana", "LinkAja"];

  final selectedBank = "BCA".obs;
  final selectedWallet = "GoPay".obs;

  late TextEditingController rekeningController;
  late TextEditingController namaPemilikController;
  late TextEditingController walletHpController;

  @override
  void onInit() {
    super.onInit();
    rekeningController = TextEditingController();
    namaPemilikController = TextEditingController(text: "Budi Santoso");
    walletHpController = TextEditingController();

    _loadCurrentPaymentSettings();
  }

  void _loadCurrentPaymentSettings() {
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profile = Get.find<ProfileController>();
        final name = profile.bankName.value;
        final account = profile.bankAccount.value;

        if (wallets.contains(name)) {
          isWalletEnabled.value = true;
          selectedWallet.value = name;
          walletHpController.text = account;
        } else if (banks.contains(name)) {
          isBankEnabled.value = true;
          selectedBank.value = name;
          rekeningController.text = account;
          namaPemilikController.text = profile.nama.value;
        } else if (name.toLowerCase() == 'tunai' || name.toLowerCase() == 'cash' || name.toLowerCase() == 'bayar di tempat') {
          isCashEnabled.value = true;
        } else {
          // Default fallback
          isWalletEnabled.value = true;
          selectedWallet.value = 'GoPay';
          walletHpController.text = account;
        }
      } else {
        isWalletEnabled.value = true;
        walletHpController.text = "08123456789";
      }
    } catch (e) {
      isWalletEnabled.value = true;
      walletHpController.text = "08123456789";
    }
  }

  @override
  void onClose() {
    rekeningController.dispose();
    namaPemilikController.dispose();
    walletHpController.dispose();
    super.onClose();
  }

  Future<void> saveSettings() async {
    // Validation
    if (!isBankEnabled.value && !isWalletEnabled.value && !isCashEnabled.value) {
      Get.snackbar(
        "Peringatan",
        "Harap aktifkan minimal satu metode pembayaran.",
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isBankEnabled.value) {
      if (rekeningController.text.trim().isEmpty) {
        Get.snackbar(
          "Peringatan",
          "Nomor rekening bank tidak boleh kosong.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (namaPemilikController.text.trim().isEmpty) {
        Get.snackbar(
          "Peringatan",
          "Nama pemilik rekening tidak boleh kosong.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    if (isWalletEnabled.value) {
      if (walletHpController.text.trim().isEmpty) {
        Get.snackbar(
          "Peringatan",
          "Nomor handphone e-wallet tidak boleh kosong.",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade900,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    // Sync to ProfileController and update on backend API
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profile = Get.find<ProfileController>();
        String finalBankName = "";
        String finalBankAccount = "";
        
        // Priority for active methods in profile display: Wallet > Bank > Cash
        if (isWalletEnabled.value) {
          finalBankName = selectedWallet.value;
          finalBankAccount = walletHpController.text;
        } else if (isBankEnabled.value) {
          finalBankName = selectedBank.value;
          finalBankAccount = rekeningController.text;
        } else if (isCashEnabled.value) {
          finalBankName = "Tunai";
          finalBankAccount = "Bayar langsung di tempat";
        }

        final success = await profile.updateProfile(
          newNama: profile.nama.value,
          newProdi: profile.prodi.value,
          newBio: profile.bio.value,
          newBankName: finalBankName,
          newBankAccount: finalBankAccount,
        );

        if (!success) {
          Get.snackbar(
            "Gagal",
            "Gagal memperbarui metode pembayaran di server.",
            backgroundColor: Colors.red.shade50,
            colorText: Colors.red.shade900,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }
    } catch (e) {
      debugPrint("Gagal sinkronisasi dengan ProfileController: $e");
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan koneksi saat menyimpan preferensi.",
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.snackbar(
      "Berhasil",
      "Preferensi pembayaran berhasil disimpan!",
      backgroundColor: const Color(0xFF190000),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.back();
    });
  }
}
