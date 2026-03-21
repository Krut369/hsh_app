import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
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
    chatGroups.assignAll([
      ChatGroup(
        id: '1',
        name: 'Pavitra Group',
        memberIds: List.generate(38, (index) => 'stud_$index').toList(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        unreadCount: 0,
        lastMessage: ChatMessage(
          id: 'm1',
          groupId: '1',
          senderId: 'admin',
          senderName: 'Admin',
          content: 'The new timings will be updated by tomorrow.',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isAdmin: true,
        ),
      ),
      ChatGroup(
        id: '2',
        name: 'Param Group',
        memberIds: List.generate(42, (index) => 'stud_$index').toList(),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
        unreadCount: 3,
        lastMessage: ChatMessage(
          id: 'm2',
          groupId: '2',
          senderId: 'u1',
          senderName: 'Smit',
          content: 'Thank you for the update!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ),
      ChatGroup(
        id: '3',
        name: 'Parmanand Group',
        memberIds: List.generate(25, (index) => 'stud_$index').toList(),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        lastMessage: ChatMessage(
          id: 'm3',
          groupId: '3',
          senderId: 'u2',
          senderName: 'Rahul',
          content: 'Sir, when will the mess timing change?',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
      ),
      ChatGroup(
        id: '4',
        name: 'Pulkit Group',
        memberIds: List.generate(30, (index) => 'stud_$index').toList(),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastMessage: ChatMessage(
          id: 'm4',
          groupId: '4',
          senderId: 'admin',
          senderName: 'Admin',
          content: 'Good morning everyone!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isAdmin: true,
        ),
      ),
    ]);
  }
}

class HostelChatGroupsScreen extends StatelessWidget {
  const HostelChatGroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HostelChatGroupsController());

    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D507B)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Hostel Chat Groups',
          style: TextStyle(
              color: Color(0xFF1D3557),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF2D507B)),
              onPressed: () {}),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'ACTIVE GROUPS',
              style: TextStyle(
                  color: Color(0xFF2D507B),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.2),
            ),
          ),
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.chatGroups.length,
                  itemBuilder: (context, index) {
                    final group = controller.chatGroups[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GroupCard(
                        group: group,
                        onTap: () =>
                            context.push('/leader/chat/messages', extra: group),
                      ),
                    );
                  },
                )),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Text('Need another group?',
                      style: TextStyle(
                          color: Color(0xFF1D3557),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.push('/leader/chat/create'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1D6EB7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      child: const Text('Create New Group',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
