import 'package:get/get.dart';

import '../controllers/kyc_pending_controller.dart';

class KycPendingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KycPendingController>(
      () => KycPendingController(),
    );
  }
}
