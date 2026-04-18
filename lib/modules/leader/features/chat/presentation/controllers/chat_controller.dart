import 'package:get/get.dart';
import '../../../../../../models/chat_group_model.dart';

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
          timestamp: DateTime(now.year, now.month, now.day, 2, 44),
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
