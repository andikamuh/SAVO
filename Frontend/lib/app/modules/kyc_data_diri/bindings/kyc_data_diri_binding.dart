import 'package:get/get.dart';

import '../controllers/kyc_data_diri_controller.dart';

class KycDataDiriBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycDataDiriController>(
      () => KycDataDiriController(),
    );
  }
}
