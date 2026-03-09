import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Authentication Service
class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  /// Login
  Future<ApiResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.login,
      body: {
        'email': username,  // Backend expects 'email' field
        'password': password,
      },
      includeAuth: false,
    );

    // Save token if login successful
    if (response.success && response.data != null) {
      // Handle nested data structure: { data: { token: ... } } vs { token: ... }
      final responseData = response.data['data'] ?? response.data;
      final token = responseData['token'];
      
      if (token != null) {
        await _apiClient.setToken(token);
      } else {
        print('⚠️ Token not found in login response');
      }
    }

    return response;
  }

  /// Register
  Future<ApiResponse> register({
    required String username,
    required String password,
    required String name,
    required String role,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
  }) async {
    return await _apiClient.post(
      ApiConstants.register,
      body: {
        'username': username,
        'password': password,
        'name': name,
        'role': role,
        if (roomNumber != null) 'room_number': roomNumber,
        if (hostelBlock != null) 'hostel_block': hostelBlock,
        if (phone != null) 'phone': phone,
      },
      includeAuth: false,
    );
  }

  /// Logout
  Future<void> logout() async {
    await _apiClient.clearToken();
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _apiClient.token != null;
  }

  /// Get current token
  String? getToken() {
    return _apiClient.token;
  }
}