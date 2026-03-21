import 'package:flutter/foundation.dart';
import '../sources/auth_api_service.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(String email, String password);
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
  });
  Future<void> setToken(String token);
  Future<void> clearToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<AuthUserModel> login(String email, String password) async {
    debugPrint('AuthRemoteDataSourceImpl.login: attempting with email: $email');
    final response = await _apiService.login({
      'email': email,
      'password': password,
    });

    // Retrofit already handles the body and mapping if it's correct
    // But since the backend returns a Map, we might need to handle HttpResponse
    if (response.response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
          'Login failed with status ${response.response.statusCode}');
    }
  }

  @override
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
  }) async {
    final response = await _apiService.register({
      'username': email, // Backend uses username as email usually
      'password': password,
      'name': name,
      'role': role,
      if (roomNumber != null) 'room_number': roomNumber,
      if (hostelBlock != null) 'hostel_block': hostelBlock,
      if (phone != null) 'phone': phone,
    });

    return response.response.statusCode == 200 ||
        response.response.statusCode == 201;
  }

  @override
  Future<void> setToken(String token) async {
    // This logic might move to interceptors in Dio, but for now we keep the interface
  }

  @override
  Future<void> clearToken() async {
    // Clear logic handled in interceptors or shared prefs
  }
}
