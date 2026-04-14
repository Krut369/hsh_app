import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';
import 'package:hsh_app/controllers/chat_controller.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

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
      backgroundColor: AppColors.mainBackground,
      body: Obx(() {
        final allConversations = controller.conversations;
        final searchQuery = _searchController.text.toLowerCase();

        final conversations = allConversations.where((chat) {
          return chat.name.toLowerCase().contains(searchQuery);
        }).toList();

        return Column(
          children: [
            // Navy Arc Header
            _buildHeader(context),

            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Search message...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 15),
                    prefixIcon:
                        const Icon(Icons.search, color: AppColors.headerBlue),
                    filled: true,
                    fillColor: Colors.white,
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
                  ? const ChatEmptyState()
                  : isGridView
                      ? GridView.builder(
                          padding: const EdgeInsets.all(20),
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
                                Get.toNamed('/student/chat/details',
                                    arguments: chat.id);
                              },
                            );
                          },
                        )
                      : ListView.builder(
                          itemCount: conversations.length,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                          itemBuilder: (context, index) {
                            final chat = conversations[index];
                            final lastMessage = chat.lastMessage;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: ChatListTile(
                                name: chat.name,
                                message: lastMessage?.text ?? '',
                                time: lastMessage?.timeString ?? '',
                                unreadCount: chat.unreadCount,
                                isOnline: chat.isOnline,
                                onTap: () {
                                  Get.toNamed('/student/chat/details',
                                      arguments: chat.id);
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 24,
        left: 12,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: BorderRadius.only(
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
          const ModernText(
            'Messages',
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
              color: Colors.white,
              size: 24,
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
              isGridView ? Icons.view_agenda_outlined : Icons.grid_view_rounded,
              color: Colors.white,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
    );
  }
}
