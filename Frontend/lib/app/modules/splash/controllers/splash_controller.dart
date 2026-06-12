import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:savo/app/data/services/api_service.dart';
import 'package:savo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkApiAndNavigate();
  }

  Future<void> _checkApiAndNavigate() async {
    // Elegant splash delay
    await Future.delayed(const Duration(seconds: 2));
    final isApiActive = await ApiService.to.checkApiStatus();
    
    if (isApiActive) {
      final token = ApiService.to.token;
      if (token != null && token.isNotEmpty) {
        try {
          final response = await ApiService.to.getRequest('/profile');
          final rawBody = response.body;
          if (response.statusCode == 200 && rawBody != null) {
            final Map<String, dynamic> body = rawBody is Map
                ? Map<String, dynamic>.from(rawBody)
                : json.decode(rawBody.toString());
            
            if (body['status'] == 'success') {
              final user = body['data'] as Map<String, dynamic>;
              final isAdmin = user['is_admin'] == true || user['is_admin'] == 1 || user['is_admin'] == '1';
              final kycStatus = user['kyc_status'] as String? ?? 'none';

              if (!isAdmin && kycStatus != 'approved') {
                if (kycStatus == 'pending') {
                  Get.offAllNamed(Routes.KYC_PENDING);
                } else {
                  Get.offAllNamed(Routes.KYC_VERIFIKASI);
                }
              } else {
                Get.offAllNamed(Routes.MAIN);
              }
              return;
            }
          }
          // If token is invalid (e.g. 401 Unauthorized), clear it
          if (response.statusCode == 401) {
            ApiService.to.setToken(null);
          }
        } catch (e) {
          debugPrint("Splash profile check error: $e");
        }
      }
      Get.offAllNamed(Routes.ONBOARDING);
    } else {
      Get.offAllNamed(Routes.MAINTENANCE);
    }
  }
}
