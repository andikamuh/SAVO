import 'package:get/get.dart';
import '../controllers/otp_verifikasi_controller.dart';

class OtpVerifikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerifikasiController>(
      () => OtpVerifikasiController(),
    );
  }
}
