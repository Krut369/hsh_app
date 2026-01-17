import 'package:hsh_app/models/chat_message_model.dart';

class ChatConversation {
  final String id;
  final String name;
  final List<ChatMessage> messages;
  final bool isOnline;
  final int unreadCount;

  ChatConversation({
    required this.id,
    required this.name,
    required this.messages,
    this.isOnline = false,
    this.unreadCount = 0,
  });

  ChatMessage? get lastMessage => messages.isEmpty ? null : messages.last;
}
