import 'package:get/get.dart';
import '../controllers/detail_gig_controller.dart';

class DetailGigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailGigController>(
      () => DetailGigController(),
    );
  }
}
