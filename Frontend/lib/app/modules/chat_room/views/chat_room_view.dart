import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controllers/chat_room_controller.dart';

class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Get.back(),
        ),
        title: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (controller.partnerId.value != 0) {
              Get.toNamed(
                Routes.PUBLIC_PROFILE,
                arguments: {'partnerId': controller.partnerId.value},
              );
            }
          },
          child: Row(
            children: [
              Obx(() {
                final av = controller.posterAvatar.value;
                return CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: av.isNotEmpty ? NetworkImage(av) : null,
                  child: av.isEmpty
                      ? Text(
                          controller.posterName.value.isNotEmpty
                              ? controller.posterName.value[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                );
              }),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                      controller.posterName.value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 10),
                        const SizedBox(width: 2),
                        const Text(
                          '4.9',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(Helper)',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Gig Context Panel
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFA),
                border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'GIG CONTEXT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() {
                          final text = controller.title.value;
                          final display = text.length > 28 ? "${text.substring(0, 26)}..." : text;
                          return Text(
                            display,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Obx(() => Text(
                    controller.price.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  )),
                ],
              ),
            ),

            // Message List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primaryDark),
                  );
                }
                if (controller.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.chat_bubble_outline,
                            size: 48, color: AppColors.textSecondary),
                        SizedBox(height: 8),
                        Text(
                          'Belum ada pesan. Mulai percakapan!',
                          style: TextStyle(
                              fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  itemCount: controller.messages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Date separator
                      return Center(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Hari Ini',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = controller.messages[index - 1];
                    return _buildMessageBubble(msg);
                  },
                );
              }),
            ),

            // Message Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              color: Colors.white,
              child: Row(
                children: [
                  // Suffix plus button
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Kirim Gambar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildSourceOption(
                                    icon: Icons.camera_alt_rounded,
                                    label: 'Kamera',
                                    onTap: () {
                                      Get.back();
                                      controller.sendImage(ImageSource.camera);
                                    },
                                  ),
                                  _buildSourceOption(
                                    icon: Icons.photo_library_rounded,
                                    label: 'Galeri',
                                    onTap: () {
                                      Get.back();
                                      controller.sendImage(ImageSource.gallery);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Icon(Icons.add, color: AppColors.textPrimary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Chat TextField
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.messageController,
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                              decoration: const InputDecoration(
                                hintText: 'Ketik pesan...',
                                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              ),
                              onSubmitted: (val) => controller.sendMessage(),
                            ),
                          ),
                          // Send Button
                          Obx(() => GestureDetector(
                            onTap: controller.isSending.value
                                ? null
                                : () => controller.sendMessage(),
                            child: Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: controller.isSending.value
                                    ? Colors.grey.shade400
                                    : Colors.black,
                                shape: BoxShape.circle,
                              ),
                              child: controller.isSending.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.send, color: Colors.white, size: 16),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: msg.isSender ? AppColors.primaryDark : const Color(0xFFFAF6F6),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isSender ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight: msg.isSender ? const Radius.circular(4) : const Radius.circular(16),
          ),
          border: msg.isSender ? null : Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (msg.imageUrl.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: msg.imageUrl.startsWith('http')
                    ? Image.network(
                        msg.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.grey.shade100,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
                        },
                      )
                    : Image.file(
                        File(msg.imageUrl),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.broken_image, size: 48, color: Colors.grey);
                        },
                      ),
              ),
              if (msg.text.isNotEmpty) const SizedBox(height: 8),
            ],
            if (msg.text.isNotEmpty)
              Text(
                msg.text,
                style: TextStyle(
                  fontSize: 13.5,
                  color: msg.isSender ? Colors.white : AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 6),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: 9,
                    color: msg.isSender ? Colors.white70 : AppColors.textSecondary,
                  ),
                ),
                if (msg.isSender) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 11,
                    color: msg.isRead ? Colors.white : Colors.white60,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1EC8C8).withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
