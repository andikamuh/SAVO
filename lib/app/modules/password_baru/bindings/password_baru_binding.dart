import 'package:get/get.dart';
import '../controllers/password_baru_controller.dart';

class PasswordBaruBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PasswordBaruController>(
      () => PasswordBaruController(),
    );
  }
}
