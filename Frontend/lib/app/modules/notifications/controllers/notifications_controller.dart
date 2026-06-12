import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class AppNotification {
  final String id;
  final String title;
  final String description;
  final String type; // 'pekerjaan' or 'sistem'
  final DateTime timestamp;
  final RxBool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.timestamp,
    bool isRead = false,
  }) : this.isRead = isRead.obs;
}

class NotificationsController extends GetxController {
  // Tabs: 'Semua', 'Pekerjaan', 'Sistem'
  final currentTab = 'Semua'.obs;
  
  final notifications = <AppNotification>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  void changeTab(String tab) {
    currentTab.value = tab;
  }

  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      final response = await ApiService.to.getRequest('/notifications');
      if (response.statusCode == 200 && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        if (body['status'] == 'success') {
          final data = body['data'] as List<dynamic>;
          notifications.value = data.map((item) {
            final parsedTime = item['created_at'] != null 
                ? DateTime.tryParse(item['created_at'].toString()) ?? DateTime.now()
                : DateTime.now();
            return AppNotification(
              id: item['id'].toString(),
              title: item['title'] ?? '',
              description: item['description'] ?? '',
              type: item['type'] ?? 'sistem',
              timestamp: parsedTime,
              isRead: (item['is_read'] == true || item['is_read'] == 1 || item['is_read'] == "1"),
            );
          }).toList();
        }
      }
    } catch (e) {
      debugPrint("Gagal memuat notifikasi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markAsRead(String id) async {
    final notif = notifications.firstWhereOrNull((n) => n.id == id);
    if (notif == null || notif.isRead.value) return;
    
    // Mark as read locally first for fast feedback
    notif.isRead.value = true;
    
    try {
      await ApiService.to.putRequest('/notifications/$id/read', {});
    } catch (e) {
      debugPrint("Gagal menandai dibaca di server: $e");
    }
  }

  Future<void> markAllAsRead() async {
    for (var notif in notifications) {
      if (!notif.isRead.value) {
        markAsRead(notif.id);
      }
    }
  }

  List<AppNotification> get filteredNotifications {
    if (currentTab.value == 'Semua') {
      return notifications;
    } else if (currentTab.value == 'Pekerjaan') {
      return notifications.where((n) => n.type == 'pekerjaan').toList();
    } else {
      return notifications.where((n) => n.type == 'sistem').toList();
    }
  }
}
