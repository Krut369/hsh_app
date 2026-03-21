import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> login(String email, String password);
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
  });
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
  Future<bool> isLoggedIn();
}
