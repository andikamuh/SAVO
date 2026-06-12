import 'dart:async';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';

class ChatRoom {
  final int id;
  final int partnerId;
  final String partnerName;
  final String partnerAvatar;
  final String partnerRole;
  final String gigTitle;
  final String gigPrice;
  final String lastMessage;
  final String lastTime;
  final int unreadCount;
  final int currentUserId;

  ChatRoom({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatar,
    required this.partnerRole,
    required this.gigTitle,
    required this.gigPrice,
    required this.lastMessage,
    required this.lastTime,
    required this.unreadCount,
    required this.currentUserId,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json, int myId) {
    final requesterId = json['requester_id'] as int? ?? 0;
    final helper = json['helper'] as Map<String, dynamic>?;
    final requester = json['requester'] as Map<String, dynamic>?;
    final gig = json['gig'] as Map<String, dynamic>?;

    // Partner is whoever is NOT me
    Map<String, dynamic>? partner;
    String role = '';
    int partnerId = 0;
    if (myId == requesterId) {
      partner = helper;
      role = 'Helper';
      partnerId = json['helper_id'] as int? ?? 0;
    } else {
      partner = requester;
      role = 'Peminta';
      partnerId = requesterId;
    }

    final partnerName = partner?['name'] as String? ?? 'Unknown';
    final partnerAvatar = partner?['avatar_url'] as String? ?? '';
    final gigTitle = gig?['title'] as String? ?? '';
    final gigPrice = gig?['price'] != null ? 'Rp ${_formatPrice(gig!['price'])}' : '';

    return ChatRoom(
      id: json['id'] as int? ?? 0,
      partnerId: partnerId,
      partnerName: partnerName,
      partnerAvatar: partnerAvatar,
      partnerRole: role,
      gigTitle: gigTitle,
      gigPrice: gigPrice,
      lastMessage: '',
      lastTime: _formatTime(json['updated_at'] as String? ?? ''),
      unreadCount: 0,
      currentUserId: myId,
    );
  }

  static String _formatPrice(dynamic price) {
    final p = (price is num) ? price.toInt() : (double.tryParse('$price') ?? 0).toInt();
    return p.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }

  static String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final now = DateTime.now();
      if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
        final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final ampm = dt.hour >= 12 ? 'PM' : 'AM';
        return '${h.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $ampm';
      }
      final diff = now.difference(dt).inDays;
      if (diff == 1) return 'Kemarin';
      return '$diff hari lalu';
    } catch (_) {
      return '';
    }
  }
}

class ChatController extends GetxController {
  final rooms = <ChatRoom>[].obs;
  final isLoading = true.obs;
  final totalUnread = 0.obs;
  int _currentUserId = 0;
  Timer? _pollingTimer;

  final isSearching = false.obs;
  final searchQuery = "".obs;

  List<ChatRoom> get filteredRooms {
    if (searchQuery.value.trim().isEmpty) {
      return rooms;
    }
    final query = searchQuery.value.toLowerCase();
    return rooms.where((room) {
      final name = room.partnerName.toLowerCase();
      final title = room.gigTitle.toLowerCase();
      return name.contains(query) || title.contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadRooms();
    // Refresh room list every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadRooms());
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadRooms() async {
    try {
      // Load current user id from profile if needed
      if (_currentUserId == 0) {
        final profileResp = await ApiService.to.getRequest('/profile');
        if (profileResp.statusCode == 200 && profileResp.body != null) {
          _currentUserId = profileResp.body['data']?['id'] as int? ?? 0;
        }
      }

      final response = await ApiService.to.getRequest('/chats');
      if (response.statusCode == 200 && response.body != null) {
        final List data = response.body['data'] as List? ?? [];
        final fetched = data
            .map((e) => ChatRoom.fromJson(e as Map<String, dynamic>, _currentUserId))
            .toList();
        rooms.assignAll(fetched);
        totalUnread.value = fetched.fold(0, (sum, r) => sum + r.unreadCount);
      }
    } catch (e) {
      // Silent fail for polling
    } finally {
      isLoading.value = false;
    }
  }
}
