import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Holiday Service
class HolidayService {
  final ApiClient _apiClient;

  HolidayService(this._apiClient);

  /// Get holiday list
  Future<ApiResponse> getHolidays() async {
    return await _apiClient.get(ApiConstants.holidayList);
  }

  /// Create holiday request
  Future<ApiResponse> createHolidayRequest({
    required String startDate,
    required String endDate,
    required String reason,
    String? destination,
  }) async {
    return await _apiClient.post(
      ApiConstants.holidayRequest,
      body: {
        'start_date': startDate,
        'end_date': endDate,
        'reason': reason,
        if (destination != null) 'destination': destination,
      },
    );
  }

  /// Get holiday requests
  Future<ApiResponse> getHolidayRequests({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.holidayRequest,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Update holiday request status (Admin only)
  Future<ApiResponse> updateHolidayStatus({
    required String requestId,
    required String status,
    String? comment,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.holidayRequest}/$requestId/status',
      body: {
        'status': status,
        if (comment != null) 'admin_comment': comment,
      },
    );
  }
}
