import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Notes Service
class NotesService {
  final ApiClient _apiClient;

  NotesService(this._apiClient);

  /// Get student notes
  Future<ApiResponse> getNotes() async {
    return await _apiClient.get(ApiConstants.notes);
  }

  /// Create note
  Future<ApiResponse> createNote({
    required String title,
    required String content,
    String? category,
    bool isPinned = false,
  }) async {
    return await _apiClient.post(
      ApiConstants.notes,
      body: {
        'title': title,
        'content': content,
        if (category != null) 'category': category,
        'is_pinned': isPinned,
      },
    );
  }

  /// Update note
  Future<ApiResponse> updateNote({
    required String noteId,
    String? title,
    String? content,
    String? category,
    bool? isPinned,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.notes}/$noteId',
      body: {
        if (title != null) 'title': title,
        if (content != null) 'content': content,
        if (category != null) 'category': category,
        if (isPinned != null) 'is_pinned': isPinned,
      },
    );
  }

  /// Delete note
  Future<ApiResponse> deleteNote(String noteId) async {
    return await _apiClient.delete('${ApiConstants.notes}/$noteId');
  }
}
