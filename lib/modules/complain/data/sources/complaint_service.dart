import 'dart:io';
import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Complaint Service — V2.0.0 API (/api/complains)
/// NOTE: The endpoint is /complains (not /complaints)
class ComplaintService {
  final ApiClient _apiClient;

  ComplaintService(this._apiClient);

  /// Get complaint categories
  /// GET /complains/categories
  Future<ApiResponse> getCategories() async {
    return await _apiClient.get(ApiConstants.complainsCategories);
  }

  /// File a complaint with optional photo attachments
  /// POST /complains   (multipart/form-data)
  /// Up to 5 images (JPEG/JPG/PNG, max 5MB each)
  Future<ApiResponse> createComplaint({
    required String room,      // e.g. "101-A"
    required String aadhar,    // 12-digit student Aadhar
    required String compType,  // From /categories e.g. "Electrical"
    required String compDesc,  // min 10 chars
    List<File>? images,        // up to 5 photos
  }) async {
    final additionalFields = <String, String>{
      'room': room,
      'aadhar': aadhar,
      'compType': compType,
      'compDesc': compDesc,
    };

    if (images != null && images.isNotEmpty) {
      // Use the multi-file upload capability
      return await _apiClient.uploadFiles(
        ApiConstants.complains,
        images,
        fieldName: 'images',
        additionalFields: additionalFields,
      );
    } else {
      return await _apiClient.post(
        ApiConstants.complains,
        body: additionalFields,
      );
    }
  }

  /// List complaints
  /// GET /complains
  Future<ApiResponse> getComplaints({
    String? status, // 'pending' | 'resolved' | 'reviewed'
    String? room,
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (status != null) queryParams['status'] = status;
    if (room != null) queryParams['room'] = room;

    return await _apiClient.get(
      ApiConstants.complains,
      queryParameters: queryParams,
    );
  }

  /// Get single complaint
  /// GET /complains/:id
  Future<ApiResponse> getComplaint(int id) async {
    return await _apiClient.get('${ApiConstants.complains}/$id');
  }

  /// Staff/Admin: Update complaint status or add response
  /// PATCH /complains/:id
  Future<ApiResponse> updateComplaintStatus({
    required int id,
    required String status, // 'resolved' | 'reviewed'
    String? staffResponse,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.complains}/$id',
      body: {
        'status': status,
        if (staffResponse != null) 'response': staffResponse,
      },
    );
  }

  /// Admin: Delete complaint
  /// DELETE /complains/:id
  Future<ApiResponse> deleteComplaint(int id) async {
    return await _apiClient.delete('${ApiConstants.complains}/$id');
  }

  /// Build the image URL for a complaint photo
  /// Pattern: /uploads/complains/complain_{id}_{index}.{ext}
  static String imageUrl(int complaintId, int index, {String ext = 'jpg'}) {
    return ApiConstants.complainImageUrl(complaintId, index, ext);
  }
}
