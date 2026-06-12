import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:savo/app/routes/app_pages.dart';

class ApiService extends GetxService {
  late GetConnect _connect;
  String? _token;
  late SharedPreferences _prefs;
  
  // Base URL pointing to the Laravel Backend API
  // Using 10.0.2.2 for Android Emulator fallback, and localhost for other platforms.
  // final String _baseUrl = 'https://unerased-understandably-vena.ngrok-free.dev/api/v1/savo';
  final String _baseUrl = 'https://api.freelancee.my.id/api/v1/savo';

  static ApiService get to => Get.find<ApiService>();

  String? get token => _token;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('token');
  }

  void setToken(String? token) {
    _token = token;
    if (token != null) {
      _prefs.setString('token', token);
    } else {
      _prefs.remove('token');
    }
  }

  String? get lastPickType => _prefs.getString('last_pick_type');

  Future<void> setLastPickType(String type) async {
    await _prefs.setString('last_pick_type', type);
  }

  String? get ktmImagePath => _prefs.getString('ktm_image_path');
  Future<void> setKtmImagePath(String? path) async {
    if (path != null) {
      await _prefs.setString('ktm_image_path', path);
    } else {
      await _prefs.remove('ktm_image_path');
    }
  }

  String? get selfieImagePath => _prefs.getString('selfie_image_path');
  Future<void> setSelfieImagePath(String? path) async {
    if (path != null) {
      await _prefs.setString('selfie_image_path', path);
    } else {
      await _prefs.remove('selfie_image_path');
    }
  }

  Future<void> clearKycPaths() async {
    await _prefs.remove('ktm_image_path');
    await _prefs.remove('selfie_image_path');
    await _prefs.remove('last_pick_type');
  }

  @override
  void onInit() {
    super.onInit();
    _connect = GetConnect();
    _connect.baseUrl = _baseUrl;
    _connect.timeout = const Duration(seconds: 10);
    
    // Enable auto self-signed certificates to handle incomplete CA chains/emulators SSL Handshake issues
    _connect.allowAutoSignedCert = true;

    // Request Modifier to globally inject Sanctum Bearer Token
    _connect.httpClient.addRequestModifier<dynamic>((request) {
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      return request;
    });

    // Response Interceptor to globally catch 503 Service Unavailable (API Disabled)
    _connect.httpClient.addResponseModifier<dynamic>((request, response) {
      if (response.statusCode == 503) {
        // Automatically route to maintenance page if we aren't already there
        if (Get.currentRoute != Routes.MAINTENANCE) {
          Get.offAllNamed(Routes.MAINTENANCE);
        }
      }
      return response;
    });
  }

  // Check if API is active by calling settings API
  Future<bool> checkApiStatus() async {
    try {
      final response = await _connect.get('/settings');
      debugPrint("CHECK API STATUS: Code=${response.statusCode}, Body=${response.body}, Error=${response.statusText}");
      
      if (response.statusCode == 200 && response.body != null) {
        dynamic body = response.body;
        // Fallback in case JSON isn't parsed automatically into a Map
        if (body is String) {
          body = jsonDecode(body);
        }
        
        if (body is Map) {
          final data = body['data'];
          if (data != null && data['api_enabled'] == false) {
            return false;
          }
          return true;
        }
      } else if (response.statusCode == 503) {
        return false;
      }
      // If server is completely down or unreachable, also trigger offline/maintenance view
      return false;
    } catch (e) {
      debugPrint("CHECK API STATUS EXCEPTION: $e");
      return false;
    }
  }

  // HTTP GET Wrapper
  Future<Response<T>> getRequest<T>(String path, {Map<String, String>? headers, Map<String, dynamic>? query}) {
    return _connect.get<T>(path, headers: headers, query: query);
  }

  // HTTP POST Wrapper
  Future<Response<T>> postRequest<T>(String path, dynamic body, {Map<String, String>? headers}) {
    return _connect.post<T>(path, body, headers: headers);
  }

  // HTTP PUT Wrapper
  Future<Response<T>> putRequest<T>(String path, dynamic body, {Map<String, String>? headers}) {
    return _connect.put<T>(path, body, headers: headers);
  }
}
