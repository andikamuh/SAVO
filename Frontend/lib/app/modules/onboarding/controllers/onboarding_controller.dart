import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  late PageController pageController;
  final currentPage = 0.obs;
  Timer? _timer;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Temukan Bantuan',
      'subtitle': 'Selesaikan tugas kampus lebih cepat\ndengan bantuan teman mahasiswa',
    },
    {
      'title': 'Dapatkan Uang Saku',
      'subtitle': 'Tawarkan keahlianmu dan bantu sesama\nmahasiswa untuk menambah penghasilan',
    },
    {
      'title': 'Aman & Terpercaya',
      'subtitle': 'Transaksi aman dan terverifikasi untuk\nkenyamanan kolaborasi antar mahasiswa',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (pageController.hasClients) {
        int nextPage = currentPage.value + 1;
        if (nextPage >= onboardingData.length) {
          nextPage = 0;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
    // Restart timer when user manual swiped to prevent quick auto-swipe
    _startAutoPlay();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }
}
