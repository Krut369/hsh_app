import 'package:intl/intl.dart';

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? senderName;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.senderName,
  });

  String get timeString => DateFormat('h:mm a').format(timestamp);
}
