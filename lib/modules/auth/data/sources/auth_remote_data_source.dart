import 'package:flutter/foundation.dart';
import '../sources/auth_api_service.dart';
import '../models/auth_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel> login(String email, String password);

  /// V2.0.0 register: only name, email, password required.
  Future<bool> register({
    required String email,
    required String password,
    required String name,
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
  }) async {
    final response = await _apiService.register({
      'email': email,
      'password': password,
      'name': name,
    });

    return response.response.statusCode == 200 ||
        response.response.statusCode == 201;
  }

  @override
  Future<void> setToken(String token) async {
    // Token is injected by the Dio interceptor in ApiClient
  }

  @override
  Future<void> clearToken() async {
    // Clear handled via ApiClient.clearToken() from local data source
  }
}
