import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class ProfileController extends GetxController {
  final id = 0.obs;
  final nama = 'Budi Santoso'.obs;
  final emailKampus = 'budi.santoso@students.universitasmulia.ac.id'.obs;
  final universitas = 'Universitas Mulia'.obs;
  final nim = '211100234'.obs;
  final prodi = 'Teknik Informatika'.obs;
  final bio = 'Mahasiswa Teknik Informatika semester 6 yang menyukai pemrograman mobile dan siap membantu tugas kuliah Anda.'.obs;
  final rating = 4.8.obs;
  final bankName = 'GoPay'.obs;
  final bankAccount = '08123456789'.obs;
  final avatarUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final response = await ApiService.to.getRequest('/profile');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final data = body['data'] as Map<String, dynamic>;
          id.value = data['id'] ?? 0;
          nama.value = data['name'] ?? '';
          emailKampus.value = data['email'] ?? '';
          universitas.value = data['universitas'] ?? '';
          nim.value = data['nim'] ?? '';
          prodi.value = data['prodi'] ?? '';
          bio.value = data['bio'] ?? '';
          avatarUrl.value = data['avatar_url'] ?? '';
          
          rating.value = data['rating'] != null 
              ? (data['rating'] is num ? (data['rating'] as num).toDouble() : (double.tryParse(data['rating'].toString()) ?? 4.8)) 
              : 4.8;

          // Fetch primary payment method
          final paymentMethodsList = data['payment_methods'] as List<dynamic>?;
          if (paymentMethodsList != null && paymentMethodsList.isNotEmpty) {
            final primaryMethod = paymentMethodsList.firstWhere(
              (m) => m['is_primary'] == true || m['is_primary'] == 1,
              orElse: () => paymentMethodsList.first,
            );
            bankName.value = primaryMethod['provider_name'] ?? 'GoPay';
            bankAccount.value = primaryMethod['account_number'] ?? '';
          }
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat profil: $e");
    }
  }

  Future<bool> updateProfile({
    required String newNama,
    required String newProdi,
    required String newBio,
    required String newBankName,
    required String newBankAccount,
    Uint8List? newAvatarBytes,
  }) async {
    try {
      // 1. Update profile with method spoofing if file exists to support file upload
      dynamic body;
      if (newAvatarBytes != null) {
        body = FormData({
          '_method': 'PUT',
          'name': newNama,
          'prodi': newProdi,
          'bio': newBio,
          'avatar': MultipartFile(newAvatarBytes, filename: 'avatar.jpg', contentType: 'image/jpeg'),
        });
      } else {
        body = {
          'name': newNama,
          'prodi': newProdi,
          'bio': newBio,
        };
      }

      final profileResponse = newAvatarBytes != null
          ? await ApiService.to.postRequest('/profile', body)
          : await ApiService.to.putRequest('/profile', body);

      if (profileResponse.statusCode == 200) {
        nama.value = newNama;
        prodi.value = newProdi;
        bio.value = newBio;
        
        final rawResponse = profileResponse.body;
        if (rawResponse != null) {
          final Map<String, dynamic> responseData = rawResponse is Map
              ? Map<String, dynamic>.from(rawResponse)
              : json.decode(rawResponse.toString());
          if (responseData['data'] != null) {
            avatarUrl.value = responseData['data']['avatar_url'] ?? avatarUrl.value;
          }
        }

        // Determine payment type
        final bool isEwallet = ['GoPay', 'OVO', 'DANA', 'LinkAja'].contains(newBankName);
        final String paymentType = isEwallet ? 'e_wallet' : 'bank';

        // 2. Save payment method
        if (newBankAccount.isNotEmpty) {
          final paymentResponse = await ApiService.to.postRequest('/profile/payment-methods', {
            'type': paymentType,
            'provider_name': newBankName,
            'account_number': newBankAccount,
            'account_name': newNama,
            'is_primary': true,
          });

          if (paymentResponse.statusCode == 200) {
            bankName.value = newBankName;
            bankAccount.value = newBankAccount;
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Gagal mengupdate profil ke server: $e");
      return false;
    }
  }
}
