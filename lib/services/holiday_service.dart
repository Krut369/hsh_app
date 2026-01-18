import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Holiday/Leave Service
class HolidayService {
  final ApiClient _apiClient;

  HolidayService(this._apiClient);

  /// Request a holiday/leave
  Future<ApiResponse> requestHoliday({
    required String name,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    return await _apiClient.post(
      ApiConstants.holidays,
      body: {
        'name': name,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'reason': reason,
      },
    );
  }

  /// Get holiday requests
  /// For students: returns own requests
  /// For leaders: returns all requests
  Future<ApiResponse> getHolidays({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.holidays,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get single holiday request by ID
  Future<ApiResponse> getHolidayById(String holidayId) async {
    return await _apiClient.get('${ApiConstants.holidays}/$holidayId');
  }

  /// Update holiday request status (Leader/Admin only)
  Future<ApiResponse> updateHolidayStatus({
    required String holidayId,
    required String status,
    String? note,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.holidays}/$holidayId/status',
      body: {
        'status': status,
        if (note != null) 'note': note,
      },
    );
  }

  /// Cancel holiday request
  Future<ApiResponse> cancelHoliday(String holidayId) async {
    return await _apiClient.delete('${ApiConstants.holidays}/$holidayId');
  }
}
