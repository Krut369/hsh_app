import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';
import '../models/user_model.dart';

class AuthState {
  final bool isAuthenticated;
  final Student? user;
  final String? error;

  AuthState({required this.isAuthenticated, this.user, this.error});

  factory AuthState.unauthenticated() => AuthState(isAuthenticated: false);
  factory AuthState.authenticated(Student user) => AuthState(isAuthenticated: true, user: user);
  factory AuthState.error(String message) => AuthState(isAuthenticated: false, error: message);
}

class AuthNotifier extends AsyncNotifier<AuthState> {
  static const _userKey = 'loggedInUser';

  @override
  Future<AuthState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        final user = Student.fromMap(jsonDecode(userJson));
        return AuthState.authenticated(user);
      } catch (_) {
        await prefs.remove(_userKey);
        return AuthState.unauthenticated();
      }
    }
    return AuthState.unauthenticated();
  }

  final List<Student> dummyUsers = [
    Student(username: 'student@gmail.com', password: '123456', name: 'Student User', role: UserRole.student),
    Student(username: 'laundry@gmail.com', password: '123456', name: 'Laundry Manager', role: UserRole.laundry),
    Student(username: 'complain@gmail.com', password: '123456', name: 'Complain Handler', role: UserRole.complain),
  ];

  Future<void> login(String username, String password) async {
    state = const AsyncValue.loading();
    await Future.delayed(const Duration(milliseconds: 500));

    final matchedUser = dummyUsers.firstWhereOrNull(
          (u) => u.username == username && u.password == password,
    );

    if (matchedUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, jsonEncode(matchedUser.toMap()));
      state = AsyncValue.data(AuthState.authenticated(matchedUser));
    } else {
      state = AsyncValue.data(AuthState.error('Invalid credentials'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await Future.delayed(const Duration(milliseconds: 300)); // optional buffer
    state = AsyncValue.data(AuthState.unauthenticated());
  }

}

final authProvider = AsyncNotifierProvider<AuthNotifier, AuthState>(() => AuthNotifier());
final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final isLoadingProvider = StateProvider<bool>((ref) => false);
