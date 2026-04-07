import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Notes Service
class NotesService {
  final ApiClient _apiClient;

  NotesService(this._apiClient);

  /// Get student notes
  Future<ApiResponse> getNotes({
    String? query,
    String? category,
    int page = 1,
  }) async {
    final queryParams = {
      if (query != null && query.isNotEmpty) 'q': query,
      if (category != null && category.isNotEmpty) 'category': category,
      'page': page,
    };
    return await _apiClient.get(ApiConstants.notes, queryParameters: queryParams);
  }

  /// Create note
  Future<ApiResponse> createNote({
    required String title,
    required String body,
    String? category,
    bool isPinned = false,
  }) async {
    return await _apiClient.post(
      ApiConstants.notes,
      body: {
        'title': title,
        'body': body,
        if (category != null) 'category': category,
        'isPinned': isPinned,
      },
    );
  }

  /// Update note
  Future<ApiResponse> updateNote({
    required String noteId,
    String? title,
    String? body,
    String? category,
    bool? isPinned,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.notes}/$noteId',
      body: {
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (category != null) 'category': category,
        if (isPinned != null) 'isPinned': isPinned,
      },
    );
  }

  /// Delete note
  Future<ApiResponse> deleteNote(String noteId) async {
    return await _apiClient.delete('${ApiConstants.notes}/$noteId');
  }
}
