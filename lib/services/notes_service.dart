import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Notes Service
class NotesService {
  final ApiClient _apiClient;

  NotesService(this._apiClient);

  /// Get all notes
  Future<ApiResponse> getNotes({String? category}) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;

    return await _apiClient.get(
      ApiConstants.notes,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get single note by ID
  Future<ApiResponse> getNoteById(String noteId) async {
    return await _apiClient.get('${ApiConstants.notes}/$noteId');
  }

  /// Create a new note
  Future<ApiResponse> createNote({
    required String title,
    required String body,
    String? category,
  }) async {
    return await _apiClient.post(
      ApiConstants.notes,
      body: {
        'title': title,
        'body': body,
        if (category != null) 'category': category,
      },
    );
  }

  /// Update a note
  Future<ApiResponse> updateNote({
    required String noteId,
    String? title,
    String? body,
    String? category,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.notes}/$noteId',
      body: {
        if (title != null) 'title': title,
        if (body != null) 'body': body,
        if (category != null) 'category': category,
      },
    );
  }

  /// Delete a note
  Future<ApiResponse> deleteNote(String noteId) async {
    return await _apiClient.delete('${ApiConstants.notes}/$noteId');
  }
}
