import 'package:get/get.dart';
import '../controllers/konfirmasi_gig_controller.dart';

class KonfirmasiGigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KonfirmasiGigController>(
      () => KonfirmasiGigController(),
    );
  }
}
