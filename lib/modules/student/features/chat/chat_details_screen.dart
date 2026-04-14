import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';
import 'package:hsh_app/controllers/chat_controller.dart';
import 'package:hsh_app/models/chat_conversation_model.dart';
import 'dart:async';

import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

class ChatDetailsScreen extends StatefulWidget {
  final String? conversationId;

  const ChatDetailsScreen({super.key, this.conversationId});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final ChatController controller = Get.find<ChatController>();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      if (widget.conversationId != null) {
        controller.markAsRead(widget.conversationId!);
      }
    });

    _subscription = controller.conversations.listen((_) {
      if (mounted) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conversations = controller.conversations;
      final conversation = conversations.firstWhere(
        (c) => c.id == widget.conversationId,
        orElse: () => conversations.isNotEmpty
            ? conversations.first
            : ChatConversation(id: '', name: 'Hostel Support', messages: []),
      );

      return ModernScaffold(
        backgroundColor: const Color(0xFFEBF3F5),
        body: Column(
          children: [
            // Custom Rounded Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(12, 50, 20, 32),
              decoration: BoxDecoration(
                color: AppColors.headerBlue,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 4),
                  Stack(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1.5),
                        ),
                        child: ClipOval(
                          child:
                              Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981), // Modern Green
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.headerBlue, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModernText(
                          conversation.name,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        const Text(
                          'Online',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: conversation.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const DateChip(label: 'TODAY');
                  }

                  final msg = conversation.messages[index - 1];
                  final isFirst = (index - 1) == 0 ||
                      conversation.messages[index - 2].isMe != msg.isMe;

                  return ChatBubble(
                    message: msg.text,
                    time: msg.timeString,
                    isMe: msg.isMe,
                    senderName: msg.senderName,
                    showAvatar: !msg.isMe, // Only show avatar for support
                    isFirstInSequence: isFirst,
                  );
                },
              ),
            ),
            ChatInput(
              onSend: (text) {
                controller.sendMessage(conversation.id, text);
              },
            ),
          ],
        ),
      );
    });
  }
}
