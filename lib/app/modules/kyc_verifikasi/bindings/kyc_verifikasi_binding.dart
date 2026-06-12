import 'package:get/get.dart';

import '../controllers/kyc_verifikasi_controller.dart';

class KycVerifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycVerifikasiController>(
      () => KycVerifikasiController(),
    );
  }
}
