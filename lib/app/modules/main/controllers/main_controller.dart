import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/controllers/home_controller.dart';
import '../../feed/controllers/feed_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
    
    // Auto-refresh data on tab switch
    if (index == 0) {
      try {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchActiveGig();
        }
      } catch (e) {
        debugPrint("Error auto-refreshing home: $e");
      }
    } else if (index == 1) {
      try {
        if (Get.isRegistered<FeedController>()) {
          Get.find<FeedController>().fetchGigs();
        }
      } catch (e) {
        debugPrint("Error auto-refreshing feed: $e");
      }
    } else if (index == 3) {
      try {
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().fetchProfile();
        }
      } catch (e) {
        debugPrint("Error auto-refreshing profile: $e");
      }
    }
  }
}
