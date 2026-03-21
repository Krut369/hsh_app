import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hsh_app/core/constants/app_text.dart';
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
            : ChatConversation(id: '', name: 'Support', messages: []),
      );

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black, size: 20),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(Icons.person,
                        color: AppColors.primary, size: 24),
                  ),
                  if (conversation.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Text(
                conversation.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.only(bottom: 16),
                itemCount: conversation.messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const DateChip(label: AppText.today);
                  }

                  final msg = conversation.messages[index - 1];
                  final isFirst = (index - 1) == 0 ||
                      conversation.messages[index - 2].isMe != msg.isMe;

                  return ChatBubble(
                    message: msg.text,
                    time: msg.timeString,
                    isMe: msg.isMe,
                    senderName: msg.senderName,
                    showAvatar: true,
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
