import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Student Service
class StudentService {
  final ApiClient _apiClient;

  StudentService(this._apiClient);

  /// Get student profile
  Future<ApiResponse> getProfile() async {
    return await _apiClient.get(ApiConstants.studentProfile);
  }

  /// Update student profile
  Future<ApiResponse> updateProfile({
    String? name,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
    String? profileImage,
  }) async {
    return await _apiClient.put(
      ApiConstants.studentProfile,
      body: {
        if (name != null) 'name': name,
        if (roomNumber != null) 'room_number': roomNumber,
        if (hostelBlock != null) 'hostel_block': hostelBlock,
        if (phone != null) 'phone': phone,
        if (profileImage != null) 'profile_image': profileImage,
      },
    );
  }
}
