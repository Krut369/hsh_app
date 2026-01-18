import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Chat Service
class ChatService {
  final ApiClient _apiClient;

  ChatService(this._apiClient);

  /// Get all chat groups for the user
  Future<ApiResponse> getChatGroups() async {
    return await _apiClient.get(ApiConstants.chatGroups);
  }

  /// Get single chat group by ID
  Future<ApiResponse> getChatGroupById(String groupId) async {
    return await _apiClient.get('${ApiConstants.chatGroups}/$groupId');
  }

  /// Create a new chat group (Leader only)
  Future<ApiResponse> createChatGroup({
    required String name,
    String? iconUrl,
    List<String>? memberIds,
  }) async {
    return await _apiClient.post(
      ApiConstants.chatGroups,
      body: {
        'name': name,
        if (iconUrl != null) 'icon_url': iconUrl,
        if (memberIds != null) 'member_ids': memberIds,
      },
    );
  }

  /// Get messages for a chat group
  Future<ApiResponse> getMessages({
    required String groupId,
    int? limit,
    int? offset,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (limit != null) queryParams['limit'] = limit;
    if (offset != null) queryParams['offset'] = offset;

    return await _apiClient.get(
      '${ApiConstants.chatGroups}/$groupId/messages',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Send a message to a chat group
  Future<ApiResponse> sendMessage({
    required String groupId,
    required String content,
    String type = 'text',
  }) async {
    return await _apiClient.post(
      '${ApiConstants.chatGroups}/$groupId/messages',
      body: {
        'content': content,
        'type': type,
      },
    );
  }

  /// Add members to a chat group (Leader only)
  Future<ApiResponse> addMembers({
    required String groupId,
    required List<String> memberIds,
  }) async {
    return await _apiClient.post(
      '${ApiConstants.chatGroups}/$groupId/members',
      body: {'member_ids': memberIds},
    );
  }

  /// Remove member from a chat group (Leader only)
  Future<ApiResponse> removeMember({
    required String groupId,
    required String userId,
  }) async {
    return await _apiClient.delete(
      '${ApiConstants.chatGroups}/$groupId/members/$userId',
    );
  }

  /// Mark messages as read
  Future<ApiResponse> markAsRead({
    required String groupId,
    required List<String> messageIds,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.chatGroups}/$groupId/messages/read',
      body: {'message_ids': messageIds},
    );
  }
}
