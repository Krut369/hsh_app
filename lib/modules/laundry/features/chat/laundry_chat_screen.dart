import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../student/features/chat/chat_components.dart';
import '../../../student/features/chat/chat_provider.dart';

class LaundryChatScreen extends ConsumerStatefulWidget {
  const LaundryChatScreen({super.key});

  @override
  ConsumerState<LaundryChatScreen> createState() => _LaundryChatScreenState();
}

class _LaundryChatScreenState extends ConsumerState<LaundryChatScreen> {
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
    final allConversations = ref.watch(chatProvider);
    final searchQuery = _searchController.text.toLowerCase();
    
    final conversations = allConversations.where((chat) {
       return chat.name.toLowerCase().contains(searchQuery);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Student Messages",
          style: const TextStyle(
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
      body: Column(
        children: [
          if (_isSearchVisible)
             Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search student name...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.grey[100], // Using grey for better contrast on white bg
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),
            ),
          Expanded(
            child: conversations.isEmpty
                ? const Center(child: Text('No messages'))
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
                              context.push('/laundry/chat/details', extra: chat.id);
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
                               context.push('/laundry/chat/details', extra: chat.id);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
