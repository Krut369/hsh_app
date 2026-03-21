import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/models/chat_message_model.dart';
import 'package:hsh_app/models/chat_conversation_model.dart';

class ChatController extends GetxController {
  final conversations = <ChatConversation>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialState();
  }

  void _loadInitialState() {
    conversations.assignAll([
      ChatConversation(
        id: '1',
        name: 'Hostel Support',
        isOnline: true,
        unreadCount: 1,
        messages: [
          ChatMessage(
            id: const Uuid().v4(),
            text: 'Hello! How can I help you today?',
            timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
            isMe: false,
            senderName: 'Admin',
          ),
          ChatMessage(
            id: const Uuid().v4(),
            text: 'I have a question about vehicle registration.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
            isMe: true,
          ),
          ChatMessage(
            id: const Uuid().v4(),
            text: 'Sure, please go ahead.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 24)),
            isMe: false,
            senderName: 'Admin',
          ),
          ChatMessage(
            id: const Uuid().v4(),
            text: 'Your application has been approved.',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            isMe: false,
            senderName: 'Admin',
          ),
        ],
      ),
    ]);
  }

  void sendMessage(String conversationId, String text) {
    if (text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );

    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final chat = conversations[index];
      conversations[index] = ChatConversation(
        id: chat.id,
        name: chat.name,
        messages: [...chat.messages, newMessage],
        isOnline: chat.isOnline,
        unreadCount: 0,
      );

      // Simulate auto-reply
      Future.delayed(const Duration(seconds: 2), () {
        receiveMockReply(conversationId);
      });
    }
  }

  void markAsRead(String conversationId) {
    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final chat = conversations[index];
      conversations[index] = ChatConversation(
        id: chat.id,
        name: chat.name,
        messages: chat.messages,
        isOnline: chat.isOnline,
        unreadCount: 0,
      );
    }
  }

  void receiveMockReply(String conversationId) {
    final reply = ChatMessage(
      id: const Uuid().v4(),
      text: 'Thank you for your message. We will get back to you shortly.',
      timestamp: DateTime.now(),
      isMe: false,
      senderName: 'Automated',
    );

    final index = conversations.indexWhere((c) => c.id == conversationId);
    if (index != -1) {
      final chat = conversations[index];
      conversations[index] = ChatConversation(
        id: chat.id,
        name: chat.name,
        messages: [...chat.messages, reply],
        isOnline: chat.isOnline,
        unreadCount: chat.unreadCount + 1,
      );
    }
  }

  String getConversationIdByName(String studentName) {
    final index = conversations.indexWhere(
        (chat) => chat.name.toLowerCase() == studentName.toLowerCase());

    if (index != -1) {
      return conversations[index].id;
    }

    if (studentName == 'John Doe') {
      final chat = ChatConversation(
          id: '2',
          name: 'John Doe',
          isOnline: false,
          unreadCount: 0,
          messages: []);
      conversations.add(chat);
      return '2';
    }

    final newId = const Uuid().v4();
    final newChat = ChatConversation(
      id: newId,
      name: studentName,
      isOnline: false,
      unreadCount: 0,
      messages: [],
    );
    conversations.add(newChat);
    return newId;
  }
}
