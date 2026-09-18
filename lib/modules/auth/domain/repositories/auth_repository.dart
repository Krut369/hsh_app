import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String email, String password);

  /// V2.0.0: Register only needs name, email, password.
  /// Account always created with student role.
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<bool> isLoggedIn();
}
