import 'package:get/get.dart';
import 'package:savo/app/data/services/api_service.dart';
import 'package:savo/app/routes/app_pages.dart';

class MaintenanceController extends GetxController {
  final isLoading = false.obs;

  Future<void> retryConnection() async {
    if (isLoading.value) return;
    
    isLoading.value = true;
    
    // Simulate brief loading for premium feel
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final isApiActive = await ApiService.to.checkApiStatus();
    
    isLoading.value = false;
    
    if (isApiActive) {
      Get.rawSnackbar(
        title: 'Koneksi Berhasil',
        message: 'Layanan API telah aktif kembali! Selamat berkendara di SAVO.',
        duration: const Duration(seconds: 3),
      );
      // Route back to Splash to re-initialize app flow
      Get.offAllNamed(Routes.SPLASH);
    } else {
      Get.rawSnackbar(
        title: 'Pemeliharaan Berlanjut',
        message: 'Layanan API masih dinonaktifkan oleh administrator. Silakan coba beberapa saat lagi.',
        duration: const Duration(seconds: 3),
      );
    }
  }
}
