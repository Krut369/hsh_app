import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Student Service — V2.0.0 API
/// Profile identified by 12-digit Aadhar number.
/// Aadhar is resolved from JWT by server for student self-ops;
/// app must store and pass it for profile fetch.
class StudentService {
  final ApiClient _apiClient;

  StudentService(this._apiClient);

  /// Get student profile by Aadhar
  /// GET /students/:aadhar
  Future<ApiResponse> getProfile(String aadhar) async {
    return await _apiClient.get('${ApiConstants.students}/$aadhar');
  }

  /// Update student profile
  /// PATCH /students/:aadhar
  /// Students can update: whatsAppNumber, phone, address, pinCode, bloodGroup,
  /// parent details, sports (cricket, badminton, gym), vehicle number.
  Future<ApiResponse> updateProfile({
    required String aadhar,
    String? whatsAppNumber,
    String? phone,
    String? address,
    String? pinCode,
    String? bloodGroup,
    bool? cricket,
    bool? badminton,
    bool? gym,
    String? vehicleNumber,
    String? fatherFirstName,
    String? fatherPhone,
    String? fatherProfession,
    String? motherFirstName,
    String? motherPhone,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.students}/$aadhar',
      body: {
        if (whatsAppNumber != null) 'whatsAppNumber': whatsAppNumber,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (pinCode != null) 'pinCode': pinCode,
        if (bloodGroup != null) 'bloodGroup': bloodGroup,
        if (cricket != null) 'cricket': cricket,
        if (badminton != null) 'badminton': badminton,
        if (gym != null) 'gym': gym,
        if (vehicleNumber != null) 'vehicleNumber': vehicleNumber,
        if (fatherFirstName != null) 'fatherFirstName': fatherFirstName,
        if (fatherPhone != null) 'fatherPhone': fatherPhone,
        if (fatherProfession != null) 'fatherProfession': fatherProfession,
        if (motherFirstName != null) 'motherFirstName': motherFirstName,
        if (motherPhone != null) 'motherPhone': motherPhone,
      },
    );
  }

  /// Get current user session (uses stored JWT)
  /// GET /auth/me
  Future<ApiResponse> getCurrentUser() async {
    return await _apiClient.get(ApiConstants.authMe);
  }

  /// Admin: search/filter all students
  /// GET /students/admin
  Future<ApiResponse> getAllStudents({
    String? query,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    return await _apiClient.get(
      ApiConstants.studentsAdmin,
      queryParameters: {
        if (query != null) 'q': query,
        if (status != null) 'status': status,
        'limit': limit,
        'offset': offset,
      },
    );
  }
}
