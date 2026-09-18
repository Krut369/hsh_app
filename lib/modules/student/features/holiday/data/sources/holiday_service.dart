import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Leave Service — V2.0.0 API (/api/leaves)
/// Aadhar auto-resolved from JWT for students.
class HolidayService {
  final ApiClient _apiClient;

  HolidayService(this._apiClient);

  /// Apply for leave
  /// POST /leaves
  Future<ApiResponse> createLeave({
    required String startTime, // ISO-8601 UTC e.g. "2026-09-20T10:00:00.000Z"
    required String endTime, // ISO-8601 UTC e.g. "2026-09-22T18:00:00.000Z"
    required String reason,
  }) async {
    return await _apiClient.post(
      ApiConstants.leaves,
      body: {
        'startTime': startTime,
        'endTime': endTime,
        'reason': reason,
      },
    );
  }

  /// Get leave history
  /// GET /leaves
  Future<ApiResponse> getLeaves({
    String? status, // 'pending' | 'approved' | 'rejected'
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.leaves,
      queryParameters: queryParams,
    );
  }

  /// Cancel / delete a pending leave request
  /// DELETE /leaves/:id
  /// Only works while status == 'pending'
  Future<ApiResponse> deleteLeave(int id) async {
    return await _apiClient.delete('${ApiConstants.leaves}/$id');
  }

  /// Admin: Approve or reject a leave request
  /// PATCH /leaves/admin/:id
  Future<ApiResponse> updateLeaveStatus({
    required int id,
    required String status, // 'approved' | 'rejected'
    String? comment,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.leavesAdmin}/$id',
      body: {
        'status': status,
        if (comment != null) 'comment': comment,
      },
    );
  }

  // ── Backward compatibility aliases for HolidayController ─────────────────

  /// Alias for getLeaves()
  Future<ApiResponse> getHolidayRequests() async => getLeaves();

  /// Alias for createLeave(...)
  Future<ApiResponse> createHolidayRequest({
    required String startDate,
    required String endDate,
    required String reason,
    String? destination,
  }) async {
    return createLeave(
      startTime: startDate,
      endTime: endDate,
      reason: destination != null ? '$reason (Destination: $destination)' : reason,
    );
  }
}
