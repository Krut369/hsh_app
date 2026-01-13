import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/modules/student/features/chat/models/chat_message.dart';
import 'package:hsh_app/modules/student/features/chat/models/chat_conversation.dart';

// --- State Notifier ---

class ChatNotifier extends StateNotifier<List<ChatConversation>> {
  ChatNotifier() : super(_initialState);

  static final List<ChatConversation> _initialState = [
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
  ];

  void sendMessage(String conversationId, String text) {
    if (text.trim().isEmpty) return;

    final newMessage = ChatMessage(
      id: const Uuid().v4(),
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
    );

    state = [
      for (final chat in state)
        if (chat.id == conversationId)
          ChatConversation(
            id: chat.id,
            name: chat.name,
            messages: [...chat.messages, newMessage],
            isOnline: chat.isOnline,
            unreadCount: 0, // Reset unread count on reply
          )
        else
          chat
    ];
    
    // Simulate auto-reply for demo
    Future.delayed(const Duration(seconds: 2), () {
       _receiveMockReply(conversationId);
    });
  }
  
  void markAsRead(String conversationId) {
     state = [
      for (final chat in state)
        if (chat.id == conversationId)
          ChatConversation(
            id: chat.id,
            name: chat.name,
            messages: chat.messages,
            isOnline: chat.isOnline,
            unreadCount: 0,
          )
        else
          chat
    ];
  }

  void _receiveMockReply(String conversationId) {
    final reply = ChatMessage(
      id: const Uuid().v4(),
      text: 'Thank you for your message. We will get back to you shortly.',
      timestamp: DateTime.now(),
      isMe: false,
      senderName: 'Automated',
    );

    state = [
      for (final chat in state)
        if (chat.id == conversationId)
          ChatConversation(
            id: chat.id,
            name: chat.name,
            messages: [...chat.messages, reply],
            isOnline: chat.isOnline,
            unreadCount: chat.unreadCount + 1,
          )
        else
          chat
    ];
  }
  String getConversationIdByName(String studentName) {
    // Attempt to find existing chat
    final existingParams = state.firstWhere(
      (chat) => chat.name.toLowerCase() == studentName.toLowerCase(),
      orElse: () => ChatConversation(id: '', name: '', messages: []),
    );

    if (existingParams.id.isNotEmpty) {
      return existingParams.id;
    }

    // specific hack for the demo to always have "John Doe"
    if (studentName == 'John Doe') {
        final chat = ChatConversation(
          id: '2', 
          name: 'John Doe', 
          isOnline: false, 
          unreadCount: 0,
          messages: []
        );
        state = [...state, chat];
        return '2';
    }

    // Create new temporary chat for this student if not found
    final newId = const Uuid().v4();
    final newChat = ChatConversation(
      id: newId,
      name: studentName,
      isOnline: false, 
      unreadCount: 0,
      messages: [],
    );
    state = [...state, newChat];
    return newId;
  }
}

// --- Provider ---

final chatProvider = StateNotifierProvider<ChatNotifier, List<ChatConversation>>((ref) {
  return ChatNotifier();
});
