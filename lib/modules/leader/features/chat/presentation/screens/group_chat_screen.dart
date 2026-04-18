import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hsh_app/models/chat_group_model.dart';
import '../widgets/chat_message_bubble.dart';

@RoutePage()
class GroupChatScreen extends StatefulWidget {
  final ChatGroup group;

  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      id: '1',
      groupId: '1',
      senderId: 'u1',
      senderName: 'Rahul',
      content: 'Sir, when will the mess timing change? Some of us have late labs starting next week.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ChatMessage(
      id: '2',
      groupId: '1',
      senderId: 'admin',
      senderName: 'Admin',
      content: 'The new timings will be updated by tomorrow evening. We are coordinating with the kitchen staff. Please check the notice board.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isAdmin: true,
    ),
    ChatMessage(
      id: '3',
      groupId: '1',
      senderId: 'u2',
      senderName: 'Smit',
      content: 'Thank you for the update! Looking forward to it.',
      type: MessageType.text,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().toString(),
            groupId: widget.group.id,
            senderId: 'admin',
            senderName: 'Admin',
            content: _messageController.text.trim(),
            type: MessageType.text,
            timestamp: DateTime.now(),
            isAdmin: true,
          ),
        );
        _messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5A80),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.group.name,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '${widget.group.memberCount} members',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('TODAY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageBubble(message: _messages[index]);
              },
            ),
          ),
          
          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(icon: const Icon(Icons.sentiment_satisfied_alt), onPressed: () {}),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D5A80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
