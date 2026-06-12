import 'package:get/get.dart';
import '../controllers/pengaturan_pembayaran_controller.dart';

class PengaturanPembayaranBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengaturanPembayaranController>(
      () => PengaturanPembayaranController(),
    );
  }
}
