import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Attendance Service
class AttendanceService {
  final ApiClient _apiClient;

  AttendanceService(this._apiClient);

  /// Mark attendance (Student via QR or Leader manual entry)
  Future<ApiResponse> markAttendance({
    required String eventType,
    String? qrData,
    String? userId, // For manual entry by leaders
  }) async {
    return await _apiClient.post(
      ApiConstants.attendanceMark,
      body: {
        'event_type': eventType,
        if (qrData != null) 'qr_data': qrData,
        if (userId != null) 'user_id': userId,
      },
    );
  }

  /// Get attendance history
  Future<ApiResponse> getAttendanceHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? eventType,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (eventType != null) queryParams['event_type'] = eventType;

    return await _apiClient.get(
      ApiConstants.attendanceHistory,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get attendance statistics
  Future<ApiResponse> getAttendanceStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    return await _apiClient.get(
      '${ApiConstants.attendanceHistory}/stats',
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }
}
