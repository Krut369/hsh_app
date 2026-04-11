import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';
import '../sources/auth_local_data_source.dart';
import '../sources/auth_remote_data_source.dart';
import '../../../../core/enums/user_role.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final normalizedEmail = email.toLowerCase().trim();

    // Check for static "Test" accounts
    if (password == '123456') {
      AuthUserModel? staticUser;
      if (normalizedEmail == 'student@gmail.com') {
        staticUser = _createMockUser(normalizedEmail, 'Static Student', UserRole.student);
      } else if (normalizedEmail == 'laundry@gmail.com') {
        staticUser = _createMockUser(normalizedEmail, 'Static Laundry', UserRole.laundry);
      } else if (normalizedEmail == 'complain@gmail.com') {
        staticUser = _createMockUser(normalizedEmail, 'Static Complaint', UserRole.complain);
      } else if (normalizedEmail == 'leader@gmail.com') {
        staticUser = _createMockUser(normalizedEmail, 'Static Leader', UserRole.leader);
      }

      if (staticUser != null) {
        await _localDataSource.saveUser(staticUser);
        if (staticUser.token != null) {
          await _localDataSource.saveToken(staticUser.token!);
          await _remoteDataSource.setToken(staticUser.token!);
        }
        return staticUser.toEntity();
      }
    }

    final AuthUserModel userModel =
        await _remoteDataSource.login(email, password);
    final token = userModel.token;

    if (token != null) {
      await _localDataSource.saveToken(token);
      await _remoteDataSource.setToken(token);
    }

    await _localDataSource.saveUser(userModel);
    return userModel.toEntity();
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
    return await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
      role: role,
      roomNumber: roomNumber,
      hostelBlock: hostelBlock,
      phone: phone,
    );
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearAll();
    await _remoteDataSource.clearToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await _localDataSource.getUser();
    final token = await _localDataSource.getToken();

    if (token != null) {
      await _remoteDataSource.setToken(token);
    }

    return userModel?.toEntity();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getToken();
    return token != null && token.isNotEmpty;
  }

  AuthUserModel _createMockUser(String email, String name, UserRole role) {
    return AuthUserModel(
      email: email,
      username: name,
      name: name,
      role: role,
      token: 'static_token_${role.toBackendString}_$email',
    );
  }
}
