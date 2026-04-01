import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Complaint Service
class ComplaintService {
  final ApiClient _apiClient;

  ComplaintService(this._apiClient);

  /// Get complaint stats
  Future<ApiResponse> getComplaintStats() async {
    return await _apiClient.get(ApiConstants.complaintStats);
  }

  /// Get complaints
  Future<ApiResponse> getComplaints({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.complaints,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Create complaint
  Future<ApiResponse> createComplaint({
    required String complaintType,
    required List<Map<String, dynamic>> issues,
  }) async {
    return await _apiClient.post(
      ApiConstants.complaints,
      body: {
        'complaint_type': complaintType,
        'issues': issues,
      },
    );
  }

  /// Update complaint status (Complaint role only)
  Future<ApiResponse> updateComplaintStatus({
    required String complaintId,
    required String status,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.complaints}/$complaintId/status',
      body: {'status': status},
    );
  }
}
