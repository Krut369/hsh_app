import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../student/features/chat/chat_components.dart';
import '../../../student/features/chat/chat_provider.dart';

class LaundryChatDetailsScreen extends ConsumerStatefulWidget {
  final String? conversationId;

  const LaundryChatDetailsScreen({super.key, this.conversationId});

  @override
  ConsumerState<LaundryChatDetailsScreen> createState() => _LaundryChatDetailsScreenState();
}

class _LaundryChatDetailsScreenState extends ConsumerState<LaundryChatDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      if (widget.conversationId != null) {
          ref.read(chatProvider.notifier).markAsRead(widget.conversationId!);
      }
    });
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
    final conversations = ref.watch(chatProvider);
    final conversation = conversations.firstWhere(
      (c) => c.id == widget.conversationId,
      orElse: () => conversations.first, 
    );
    
    ref.listen(chatProvider, (previous, next) {
      final prevConv = previous?.firstWhere((c) => c.id == conversation.id, orElse: () => conversations.first);
      final nextConv = next.firstWhere((c) => c.id == conversation.id, orElse: () => conversations.first);
      
      if (nextConv.messages.length > (prevConv?.messages.length ?? 0)) {
         Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

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
                  child: Icon(Icons.person, color: AppColors.primary, size: 24),
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
              ref.read(chatProvider.notifier).sendMessage(conversation.id, text);
            },
           ),
        ],
      ),
    );
  }
}
