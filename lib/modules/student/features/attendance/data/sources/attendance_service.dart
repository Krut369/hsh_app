import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Attendance Service — V2.0.0 API
/// 5 event types: aarti | lunch | dinner | night | sabha
class AttendanceService {
  final ApiClient _apiClient;

  AttendanceService(this._apiClient);

  /// Mark attendance for current user
  /// POST /attendance
  /// Students: only today's date, own attendance only, aadhar auto-resolved from JWT.
  Future<ApiResponse> markAttendance({
    required String type, // 'aarti' | 'lunch' | 'dinner' | 'night' | 'sabha'
    bool viaCode = false,
  }) async {
    return await _apiClient.post(
      ApiConstants.attendance,
      body: {
        'type': type,
        'viaCode': viaCode,
      },
    );
  }

  /// Get attendance logs / history
  /// GET /attendance
  Future<ApiResponse> getAttendance({
    String? type,
    String? startDate, // YYYY-MM-DD
    String? endDate,   // YYYY-MM-DD
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (type != null) queryParams['type'] = type;
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    return await _apiClient.get(
      ApiConstants.attendance,
      queryParameters: queryParams,
    );
  }

  /// Get scheduled Sabha sessions
  /// GET /attendance/sabhas
  Future<ApiResponse> getSabhas() async {
    return await _apiClient.get(ApiConstants.attendanceSabhas);
  }

  /// Get dates where attendance is actively enabled
  /// GET /attendance/dates
  Future<ApiResponse> getActiveDates() async {
    return await _apiClient.get(ApiConstants.attendanceDates);
  }

  /// Admin: schedule a Sabha session
  /// POST /attendance/admin/sabhas
  Future<ApiResponse> scheduleSabha({
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    return await _apiClient.post(
      ApiConstants.attendanceAdminSabhas,
      body: {
        'date': date,
        'startTime': startTime,
        'endTime': endTime,
      },
    );
  }
}
