import 'package:get/get.dart';
import '../controllers/penyelesaian_controller.dart';

class PenyelesaianBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenyelesaianController>(
      () => PenyelesaianController(),
    );
  }
}
