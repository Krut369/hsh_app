import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/auth_user_model.dart';
import '../sources/auth_local_data_source.dart';
import '../sources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<UserEntity?> login(String email, String password) async {
    final AuthUserModel userModel =
        await _remoteDataSource.login(email, password);

    // V2.0.0: token is at top level of response
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
  }) async {
    return await _remoteDataSource.register(
      email: email,
      password: password,
      name: name,
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
}
