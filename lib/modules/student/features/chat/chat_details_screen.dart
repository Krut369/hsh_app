import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';
import 'package:hsh_app/controllers/chat_controller.dart';
import 'package:hsh_app/models/chat_conversation_model.dart';
import 'dart:async';

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
        backgroundColor: const Color(0xFFEFF6FF), // Light blue background
        body: Column(
          children: [
            // Custom Rounded Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
              decoration: const BoxDecoration(
                color: AppColors.headerBlue,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Icon(Icons.person, color: AppColors.headerBlue.withOpacity(0.5), size: 32),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.headerBlue, width: 2),
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
                        const ModernText(
                          'Online',
                          color: Colors.greenAccent,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
