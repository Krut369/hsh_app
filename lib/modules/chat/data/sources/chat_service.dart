import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Chat Service
class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  /// Get student messages
  Future<ApiResponse> getMessages() async {
    return await _apiClient.get(ApiConstants.chatMessages);
  }

  /// Send message
  Future<ApiResponse> sendMessage({
    required String content,
    String? type,
    String? receiverId,
  }) async {
    return await _apiClient.post(
      ApiConstants.chatMessages,
      body: {
        'content': content,
        if (type != null) 'type': type,
        if (receiverId != null) 'receiver_id': receiverId,
      },
    );
  }

  /// Get messages by group
  Future<ApiResponse> getGroupMessages(String groupId) async {
    return await _apiClient.get('${ApiConstants.chatMessages}/groups/$groupId');
  }

  /// Create chat group
  Future<ApiResponse> createChatGroup({
    required String name,
    required List<String> memberIds,
    String? description,
  }) async {
    return await _apiClient.post(
      '${ApiConstants.chatMessages}/groups',
      body: {
        'name': name,
        'member_ids': memberIds,
        if (description != null) 'description': description,
      },
    );
  }

  /// Get chat groups
  Future<ApiResponse> getChatGroups() async {
    return await _apiClient.get('${ApiConstants.chatMessages}/groups');
  }
}
