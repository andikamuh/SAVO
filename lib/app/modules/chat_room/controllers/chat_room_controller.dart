import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/api_service.dart';
import 'package:image_picker/image_picker.dart';
import '../../kyc_verifikasi/views/custom_camera_screen.dart';

class ChatMessage {
  final int id;
  final String text;
  final String imageUrl;
  final String time;
  final bool isSender;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.text,
    required this.imageUrl,
    required this.time,
    required this.isSender,
    this.isRead = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    final senderId = json['sender_id'] as int? ?? 0;
    final createdAt = json['created_at'] as String? ?? '';
    return ChatMessage(
      id: json['id'] as int? ?? 0,
      text: json['message_text'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      time: _formatTime(createdAt),
      isSender: senderId == currentUserId,
      isRead: json['is_read'] as bool? ?? false,
    );
  }

  static String _formatTime(String isoString) {
    if (isoString.isEmpty) return '';
    try {
      final dt = DateTime.parse(isoString).toLocal();
      final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final ampm = dt.hour >= 12 ? 'PM' : 'AM';
      final min = dt.minute.toString().padLeft(2, '0');
      return '${h.toString().padLeft(2, '0')}:$min $ampm';
    } catch (_) {
      return '';
    }
  }
}

class ChatRoomController extends GetxController {
  final messageController = TextEditingController();
  final messages = <ChatMessage>[].obs;
  final isSending = false.obs;
  final isLoading = true.obs;

  final partnerId = 0.obs;
  final posterName = ''.obs;
  final posterAvatar = ''.obs;
  final title = ''.obs;
  final price = ''.obs;

  int _roomId = 0;
  int _currentUserId = 0;
  int _lastMessageId = 0;
  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      _roomId = args['roomId'] as int? ?? 0;
      _currentUserId = args['currentUserId'] as int? ?? 0;
      if (args['partnerId'] != null) partnerId.value = args['partnerId'] as int? ?? 0;
      if (args['posterName'] != null) posterName.value = args['posterName'];
      if (args['posterAvatar'] != null) posterAvatar.value = args['posterAvatar'];
      if (args['title'] != null) title.value = args['title'];
      if (args['price'] != null) price.value = args['price'];
    }

    _loadMessages();
    _startPolling();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    super.onClose();
  }

  // ─── Load all messages (initial) ────────────────────────────────────────────
  Future<void> _loadMessages() async {
    if (_roomId == 0) return;
    isLoading.value = true;
    try {
      final response = await ApiService.to.getRequest('/chats/$_roomId/messages');
      if (response.statusCode == 200 && response.body != null) {
        final List data = response.body['data'] as List? ?? [];
        final fetched = data
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>, _currentUserId))
            .toList();
        messages.assignAll(fetched);
        if (fetched.isNotEmpty) {
          _lastMessageId = fetched.last.id;
        }
      }
    } catch (e) {
      debugPrint('[ChatRoom] loadMessages error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Polling: fetch only new messages every 3 seconds ───────────────────────
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchNewMessages());
  }

  Future<void> _fetchNewMessages() async {
    if (_roomId == 0) return;
    try {
      final response = await ApiService.to
          .getRequest('/chats/$_roomId/messages', query: {'after_id': '$_lastMessageId'});
      if (response.statusCode == 200 && response.body != null) {
        final List data = response.body['data'] as List? ?? [];
        if (data.isEmpty) return;
        for (final e in data) {
          final msg = ChatMessage.fromJson(e as Map<String, dynamic>, _currentUserId);
          // Only add messages we haven't added yet (avoid duplicates)
          if (msg.id > _lastMessageId) {
            messages.add(msg);
            _lastMessageId = msg.id;
          }
        }
      }
    } catch (e) {
      debugPrint('[ChatRoom] polling error: $e');
    }
  }

  // ─── Send message to API ─────────────────────────────────────────────────────
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty || isSending.value) return;

    isSending.value = true;
    messageController.clear();

    // Optimistic UI: add message locally immediately
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final optimistic = ChatMessage(
      id: tempId,
      text: text,
      imageUrl: '',
      time: _currentTime(),
      isSender: true,
      isRead: false,
    );
    messages.add(optimistic);

    try {
      final response = await ApiService.to.postRequest(
        '/chats/$_roomId/messages',
        {'message_text': text},
      );
      if (response.statusCode == 201 && response.body != null) {
        final data = response.body['data'] as Map<String, dynamic>?;
        if (data != null) {
          final realMsg = ChatMessage.fromJson(data, _currentUserId);
          // Replace optimistic message with real one
          final idx = messages.indexWhere((m) => m.id == tempId);
          if (idx != -1) {
            messages[idx] = realMsg;
          }
          if (realMsg.id > _lastMessageId) {
            _lastMessageId = realMsg.id;
          }
        }
      } else {
        // Remove optimistic message on failure
        messages.removeWhere((m) => m.id == tempId);
        Get.snackbar('Gagal', 'Pesan tidak terkirim, coba lagi.',
            snackPosition: SnackPosition.BOTTOM);
        messageController.text = text; // restore text
      }
    } catch (e) {
      messages.removeWhere((m) => m.id == tempId);
      Get.snackbar('Error', 'Koneksi bermasalah.',
          snackPosition: SnackPosition.BOTTOM);
      messageController.text = text;
      debugPrint('[ChatRoom] sendMessage error: $e');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> sendImage(ImageSource source) async {
    try {
      String imagePath = "";
      Uint8List? imageBytes;

      if (source == ImageSource.camera) {
        final dynamic pickedFile = await Get.to(() => const CustomCameraScreen(
          isFrontCamera: false,
          overlayType: CameraOverlayType.none,
        ));
        if (pickedFile == null) return;

        if (pickedFile is File) {
          imagePath = pickedFile.path;
          imageBytes = await pickedFile.readAsBytes();
        } else if (pickedFile is XFile) {
          imagePath = pickedFile.path;
          imageBytes = await pickedFile.readAsBytes();
        } else {
          final pathStr = pickedFile.toString();
          imagePath = pathStr;
          imageBytes = await File(pathStr).readAsBytes();
        }
      } else {
        final XFile? pickedFile = await ImagePicker().pickImage(
          source: source,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 80,
        );
        if (pickedFile == null) return;
        imagePath = pickedFile.path;
        imageBytes = await pickedFile.readAsBytes();
      }

      if (imagePath.isEmpty || imageBytes == null) return;

      isSending.value = true;

      // Optimistic UI for image message: add an optimistic message locally
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      final optimistic = ChatMessage(
        id: tempId,
        text: '',
        imageUrl: imagePath, // Local path fallback
        time: _currentTime(),
        isSender: true,
        isRead: false,
      );
      messages.add(optimistic);

      final form = FormData({
        'image': MultipartFile(imageBytes, filename: 'image.jpg', contentType: 'image/jpeg'),
      });

      final response = await ApiService.to.postRequest(
        '/chats/$_roomId/messages',
        form,
      );

      if (response.statusCode == 201 && response.body != null) {
        final data = response.body['data'] as Map<String, dynamic>?;
        if (data != null) {
          final realMsg = ChatMessage.fromJson(data, _currentUserId);
          final idx = messages.indexWhere((m) => m.id == tempId);
          if (idx != -1) {
            messages[idx] = realMsg;
          }
          if (realMsg.id > _lastMessageId) {
            _lastMessageId = realMsg.id;
          }
        }
      } else {
        messages.removeWhere((m) => m.id == tempId);
        Get.snackbar('Gagal', 'Gagal mengirim gambar.', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi bermasalah saat mengirim gambar: $e', snackPosition: SnackPosition.BOTTOM);
      debugPrint('[ChatRoom] sendImage error: $e');
    } finally {
      isSending.value = false;
    }
  }

  String _currentTime() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    final min = now.minute.toString().padLeft(2, '0');
    return '${h.toString().padLeft(2, '0')}:$min $ampm';
  }
}
