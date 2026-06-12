import 'package:get/get.dart';
import '../controllers/rating_helper_controller.dart';

class RatingHelperBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RatingHelperController>(
      () => RatingHelperController(),
    );
  }
}
