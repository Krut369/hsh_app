class ChatGroup {
  final String id;
  final String name;
  final String? iconUrl;
  final List<String> memberIds;
  final ChatMessage? lastMessage;
  final DateTime createdAt;
  final int unreadCount;

  ChatGroup({
    required this.id,
    required this.name,
    this.iconUrl,
    required this.memberIds,
    this.lastMessage,
    required this.createdAt,
    this.unreadCount = 0,
  });

  int get memberCount => memberIds.length;

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'iconUrl': iconUrl,
        'memberIds': memberIds,
        'lastMessage': lastMessage?.toMap(),
        'createdAt': createdAt.toIso8601String(),
        'unreadCount': unreadCount,
      };

  factory ChatGroup.fromMap(Map<String, dynamic> map) => ChatGroup(
        id: map['id'],
        name: map['name'],
        iconUrl: map['iconUrl'],
        memberIds: List<String>.from(map['memberIds']),
        lastMessage: map['lastMessage'] != null ? ChatMessage.fromMap(map['lastMessage']) : null,
        createdAt: DateTime.parse(map['createdAt']),
        unreadCount: map['unreadCount'] ?? 0,
      );
}

enum MessageType { text, image, file }

class ChatMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final bool isAdmin;

  ChatMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.isAdmin = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'groupId': groupId,
        'senderId': senderId,
        'senderName': senderName,
        'senderAvatar': senderAvatar,
        'content': content,
        'type': type.name,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
        'isAdmin': isAdmin,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'],
        groupId: map['groupId'],
        senderId: map['senderId'],
        senderName: map['senderName'],
        senderAvatar: map['senderAvatar'],
        content: map['content'],
        type: MessageType.values.firstWhere((e) => e.name == map['type']),
        timestamp: DateTime.parse(map['timestamp']),
        isRead: map['isRead'] ?? false,
        isAdmin: map['isAdmin'] ?? false,
      );
}
