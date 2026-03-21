import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Attendance Service
class AttendanceService {
  final ApiClient _apiClient;

  AttendanceService(this._apiClient);

  /// Get student attendance
  Future<ApiResponse> getAttendance({
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    if (startDate != null) queryParams['start_date'] = startDate;
    if (endDate != null) queryParams['end_date'] = endDate;

    return await _apiClient.get(
      ApiConstants.attendance,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Mark attendance (Admin/Leader)
  Future<ApiResponse> markAttendance({
    required List<String> studentIds,
    required String date,
    required String status,
    required String eventType,
  }) async {
    return await _apiClient.post(
      ApiConstants.attendance,
      body: {
        'student_ids': studentIds,
        'date': date,
        'status': status,
        'event_type': eventType,
      },
    );
  }

  /// Get attendance stats (Admin/Leader)
  Future<ApiResponse> getAttendanceStats({
    required String date,
    String? eventType,
  }) async {
    final queryParams = <String, dynamic>{'date': date};
    if (eventType != null) queryParams['event_type'] = eventType;

    return await _apiClient.get(
      ApiConstants.attendanceStats,
      queryParameters: queryParams,
    );
  }
}
