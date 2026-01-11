import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/modules/student/features/chat/chat_components.dart';

class ChatDetailsScreen extends StatelessWidget {
  const ChatDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE9F1F8),
                  child: Icon(Icons.support_agent, color: Colors.blue),
                ),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppText.hostelSupport,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      AppText.online,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 0), // Components handle padding
              children: const [
                DateChip(label: AppText.today),
                ChatBubble(
                  message: AppText.chatMsg1,
                  time: '10:42 AM',
                  isMe: false,
                  senderName: 'Admin',
                ),
                ChatBubble(
                  message: AppText.chatMsg2,
                  time: '10:45 AM',
                  isMe: true,
                ),
                ChatBubble(
                  message: AppText.chatMsg3,
                  time: '10:46 AM',
                  isMe: false,
                  senderName: 'Admin',
                ),
                ChatBubble(
                  message: AppText.chatMsg4,
                  time: '10:47 AM',
                  isMe: true,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 24, top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        AppText.read,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.done_all, size: 14, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
}
