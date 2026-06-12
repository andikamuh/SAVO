import 'package:get/get.dart';
import '../controllers/post_gig_controller.dart';

class PostGigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostGigController>(
      () => PostGigController(),
    );
  }
}
