import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'package:hsh_app/modules/leader/presentation/leader_auto_router.dart';
import 'package:hsh_app/models/chat_group_model.dart';
import 'widgets/group_card.dart';

class HostelChatGroupsController extends GetxController {
  final chatGroups = <ChatGroup>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDemoData();
  }

  void _loadDemoData() {
    // Generate dates based on the mock specifications relative to now
    final now = DateTime.now();

    chatGroups.assignAll([
      ChatGroup(
        id: '1',
        name: 'Hostel Support',
        iconUrl: 'https://i.pravatar.cc/150?img=11',
        memberIds: ['admin', 'u1'],
        createdAt: now.subtract(const Duration(days: 30)),
        unreadCount: 1,
        lastMessage: ChatMessage(
          id: 'm1',
          groupId: '1',
          senderId: 'admin',
          senderName: 'Admin',
          content: 'Your application has been ap...',
          type: MessageType.text,
          timestamp: DateTime(now.year, now.month, now.day, 2,
              44), // Mocked for '2:44 AM' if viewed currently, but time parsing matches anyway if 0 days
          isAdmin: true,
        ),
      ),
      ChatGroup(
        id: '2',
        name: 'Sarah Jenkins',
        iconUrl: 'https://i.pravatar.cc/150?img=5',
        memberIds: ['u1', 'u2'],
        createdAt: now.subtract(const Duration(days: 25)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'm2',
          groupId: '2',
          senderId: 'u2',
          senderName: 'Sarah Jenkins',
          content: 'I\'ve sent the updated lease draft f...',
          type: MessageType.text,
          timestamp: now.subtract(const Duration(days: 1)),
        ),
      ),
      ChatGroup(
        id: '3',
        name: 'Harbor Residents Group',
        iconUrl: null,
        memberIds: List.generate(25, (index) => 'stud_$index'),
        createdAt: now.subtract(const Duration(days: 20)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'm3',
          groupId: '3',
          senderId: 'u3',
          senderName: 'Mike',
          content: 'Is anyone using the gym to...',
          type: MessageType.text,
          // Fixed loosely to 2-3 days ago to trigger weekday format
          timestamp: now.subtract(const Duration(days: 3)),
        ),
      ),
      ChatGroup(
        id: '4',
        name: 'David Chen',
        iconUrl: 'https://i.pravatar.cc/150?img=15',
        memberIds: ['u1', 'u4'],
        createdAt: now.subtract(const Duration(days: 15)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'm4',
          groupId: '4',
          senderId: 'u4',
          senderName: 'David Chen',
          content: 'The coffee shop around the corn...',
          type: MessageType.text,
          timestamp: DateTime(now.year, 10, 12),
        ),
      ),
      ChatGroup(
        id: '5',
        name: 'Property Maintenance',
        iconUrl: null,
        memberIds: ['u1', 'u5'],
        createdAt: now.subtract(const Duration(days: 10)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'm5',
          groupId: '5',
          senderId: 'u5',
          senderName: 'Maintenance',
          content: 'Work order #4492 has been mark...',
          type: MessageType.text,
          timestamp: DateTime(now.year, 10, 10),
        ),
      ),
    ]);
  }
}

@RoutePage()
class HostelChatGroupsScreen extends StatelessWidget {
  const HostelChatGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HostelChatGroupsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light gray from mockup
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.chat_bubble_rounded),
        onPressed: () => context.router.push(const CreateNewGroupRoute()),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom App Bar with rounded bottom corners
          Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 20,
                left: 24,
                right: 24,
                bottom: 24),
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557), // Dark navy
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // Avatar icon box
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      'https://i.pravatar.cc/150?img=68',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person, color: Colors.white70);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Messages',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Search button
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // RECENTS header
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 28, 24, 12),
            child: Text(
              'RECENTS',
              style: TextStyle(
                color: Color(0xFF9BABBB),
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Chat groups list
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: controller.chatGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.chatGroups[index];
                    return GroupCard(
                      group: group,
                      onTap: () =>
                          context.router.push(GroupChatRoute(group: group)),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }
}
