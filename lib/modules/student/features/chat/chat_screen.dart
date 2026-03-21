import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';
import 'package:hsh_app/controllers/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController controller = Get.find<ChatController>();
  bool isGridView = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Messages",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                }
              });
            },
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
      body: Obx(() {
        final allConversations = controller.conversations;
        final searchQuery = _searchController.text.toLowerCase();

        final conversations = allConversations.where((chat) {
          return chat.name.toLowerCase().contains(searchQuery);
        }).toList();

        return Column(
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search message...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.primary),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
            Expanded(
              child: conversations.isEmpty
                  ? const Center(child: Text('No messages'))
                  : isGridView
                      ? GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                context.push('/student/chat/details',
                                    extra: chat.id);
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
                                context.push('/student/chat/details',
                                    extra: chat.id);
                              },
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }
}
