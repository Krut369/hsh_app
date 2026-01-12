import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';
import 'package:hsh_app/modules/student/features/chat/chat_provider.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    final conversations = ref.watch(chatProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppText.chat,
        showNotificationIcon: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: conversations.isEmpty
          ? const Center(child: Text('No conversations'))
          : isGridView
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final chat = conversations[index];
                    final lastMessage = chat.lastMessage;

                    return ChatGridTile(
                      name: chat.name,
                      message: lastMessage?.text ?? '',
                      time: lastMessage?.timeString ?? '',
                      unreadCount: chat.unreadCount,
                      isOnline: chat.isOnline,
                      onTap: () {
                        context.push('/student/chat/details', extra: chat.id);
                      },
                    );
                  },
                )
              : ListView.separated(
                  itemCount: conversations.length,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, indent: 84),
                  itemBuilder: (context, index) {
                    final chat = conversations[index];
                    final lastMessage = chat.lastMessage;

                    return ChatListTile(
                      name: chat.name,
                      message: lastMessage?.text ?? '',
                      time: lastMessage?.timeString ?? '',
                      unreadCount: chat.unreadCount,
                      isOnline: chat.isOnline,
                      onTap: () {
                        context.push('/student/chat/details', extra: chat.id);
                      },
                    );
                  },
                ),
    );
  }
}
