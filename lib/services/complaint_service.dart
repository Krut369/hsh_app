import 'dart:io';
import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Complaint Service
class ComplaintService {
  final ApiClient _apiClient;

  ComplaintService(this._apiClient);

  /// Create a new complaint
  /// Handles uploading images for issues if they exist
  Future<ApiResponse> createComplaint({
    required String complaintType,
    required List<Map<String, dynamic>> issues,
  }) async {
    final List<Map<String, dynamic>> processedIssues = [];

    for (final issue in issues) {
      final Map<String, dynamic> issueData = Map.from(issue);
      
      // If there is an image path, upload it first
      if (issueData.containsKey('imagePath') && issueData['imagePath'] != null) {
        final File imageFile = File(issueData['imagePath']);
        if (await imageFile.exists()) {
          final uploadResponse = await uploadImage(imageFile);
          if (uploadResponse.success && uploadResponse.data != null) {
             // Assuming backend returns { "url": "..." } or similar
             // Adjust key 'url' based on actual upload response
             issueData['image'] = uploadResponse.data['url'] ?? uploadResponse.data['file_url']; 
          }
        }
        // Remove local path before sending to API
        issueData.remove('imagePath');
      } else {
        // Ensure imagePath is removed even if null
        issueData.remove('imagePath');
      }
      processedIssues.add(issueData);
    }

    return await _apiClient.post(
      ApiConstants.complaints,
      body: {
        'complaint_type': complaintType,
        'issues': processedIssues,
      },
    );
  }

  /// Get complaints
  /// For students: returns own complaints
  /// For complaint staff: returns all complaints
  Future<ApiResponse> getComplaints({
    String? status,
    String? complaintType,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (status != null) queryParams['status'] = status;
    if (complaintType != null) queryParams['complaint_type'] = complaintType;

    return await _apiClient.get(
      ApiConstants.complaints,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get complaint statistics
  Future<ApiResponse> getComplaintStats() async {
    return await _apiClient.get('${ApiConstants.complaints}/stats');
  }

  /// Get single complaint by ID
  Future<ApiResponse> getComplaintById(String complaintId) async {
    return await _apiClient.get('${ApiConstants.complaints}/$complaintId');
  }

  /// Update complaint status (Staff only)
  Future<ApiResponse> updateComplaintStatus({
    required String complaintId,
    required String status,
    String? note,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.complaints}/$complaintId/status',
      body: {
        'status': status,
        if (note != null) 'note': note,
      },
    );
  }

  /// Upload image for complaint
  Future<ApiResponse> uploadImage(File imageFile) async {
    return await _apiClient.uploadFile(
      ApiConstants.upload,
      imageFile,
      fieldName: 'image',
    );
  }

  /// Upload multiple images
  Future<List<String>> uploadImages(List<File> images) async {
    final uploadedUrls = <String>[];

    for (final image in images) {
      final response = await uploadImage(image);
      if (response.success && response.data != null) {
        final url = response.data['url'] ?? response.data['file_url'];
        if (url != null) {
          uploadedUrls.add(url);
        }
      }
    }

    return uploadedUrls;
  }
}
