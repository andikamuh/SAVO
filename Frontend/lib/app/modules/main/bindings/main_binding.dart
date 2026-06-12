import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../feed/controllers/feed_controller.dart';
import '../../chat/controllers/chat_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<FeedController>(
      () => FeedController(),
    );
    Get.lazyPut<ChatController>(
      () => ChatController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
