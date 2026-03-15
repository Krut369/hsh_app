import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/service_provider.dart';

class AuthState {
  final bool isAuthenticated;
  final Student? user;
  final String? error;

  AuthState({required this.isAuthenticated, this.user, this.error});

  factory AuthState.unauthenticated() => AuthState(isAuthenticated: false);
  factory AuthState.authenticated(Student user) =>
      AuthState(isAuthenticated: true, user: user);
  factory AuthState.error(String message) =>
      AuthState(isAuthenticated: false, error: message);
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  static const _userKey = 'loggedInUser';

  @override
  Future<AuthState> build() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 1. Try to restore Token
    final token = prefs.getString('auth_token'); // Using literal or ApiConstants.tokenKey if imported
    if (token != null && token.isNotEmpty) {
       await serviceProvider.apiClient.setToken(token);
    }

    // 2. Check Valid Session
    if (serviceProvider.auth.isLoggedIn()) {
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        try {
          final user = Student.fromMap(jsonDecode(userJson));
          print('✅ Session restored for user: ${user.name} (${user.role})');
          return AuthState.authenticated(user);
        } catch (e) {
          print('❌ Failed to restore session: $e');
          await prefs.remove(_userKey);
          await serviceProvider.auth.logout();
          return AuthState.unauthenticated();
        }
      }
    }
    
    return AuthState.unauthenticated();
  }

  /// Login with backend API
  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();

    try {
      print('🔐 Attempting login for: $username');
      print('🌐 API URL: https://hsh-backend.onrender.com/api/v1/auth/login');

      // Call backend API
      final response = await serviceProvider.auth.login(
        username: username,
        password: password,
      );

      print('📡 Response received - Success: ${response.success}');
      print('📡 Response data: ${response.data}');
      print('📡 Response message: ${response.message}');
      print('📡 Status code: ${response.statusCode}');

      if (response.success && response.data != null) {
        // Extract user data from nested response structure
        // Backend returns: {success: true, data: {user: {...}, token: ...}}
        final responseData = response.data['data'] ?? response.data;
        final userData = responseData['user'] ?? responseData;

        print('✅ Login successful! User data: $userData');

        // Create Student object from response
        final user = Student(
          username: userData['email'] ?? userData['username'] ?? username,
          password: '', // Don't store password
          name: userData['name'] ?? 'User',
          role: _parseUserRole(userData['role'] ?? 'student'),
          roomNumber: userData['room'] ?? userData['room_number'],
          hostelBlock: userData['hostel_block'],
          phone: userData['phone'],
          profileImage: userData['avatar'] ?? userData['profile_image'],
        );

        // Save user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, jsonEncode(user.toMap()));

        state = AsyncValue.data(AuthState.authenticated(user));
        print('✅ User authenticated and saved locally');
        print('✅ User role: ${user.role.name}');
      } else {
        // Login failed
        final errorMsg = response.message ?? 'Invalid credentials';
        print('❌ Login failed: $errorMsg');
        state = AsyncValue.data(
          AuthState.error(errorMsg),
        );
      }
    } catch (e, stackTrace) {
      // Network or other error
      print('❌ Login error: $e');
      print('Stack trace: $stackTrace');
      state = AsyncValue.data(
        AuthState.error('Login failed: ${e.toString()}'),
      );
    }
  }

  /// Clear current error state (e.g., when the user starts re-typing)
  void clearError() {
    state = AsyncValue.data(AuthState.unauthenticated());
  }

  /// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await serviceProvider.auth.logout();
    state = AsyncValue.data(AuthState.unauthenticated());
  }

  /// Parse user role from string
  UserRole _parseUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'laundry':
        return UserRole.laundry;
      case 'complain':
      case 'complaint': // Backend sometimes sends 'complaint'
        return UserRole.complain;
      case 'leader':
        return UserRole.leader;
      default:
        return UserRole.student;
    }
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final isLoadingProvider = StateProvider<bool>((ref) => false);
