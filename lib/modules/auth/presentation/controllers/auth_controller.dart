import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final AuthRepository _authRepository;

  AuthController({
    required LoginUseCase loginUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _authRepository = authRepository;

  // Observables
  final RxBool isLoading = false.obs;
  final RxnString error = RxnString();
  final Rxn<UserEntity> user = Rxn<UserEntity>();
  final RxBool isAuthenticated = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkInitialAuth();
  }

  Future<void> _checkInitialAuth() async {
    isLoading.value = true;
    try {
      final currentUser = await _authRepository.getCurrentUser();
      if (currentUser != null) {
        user.value = currentUser;
        isAuthenticated.value = true;
      } else {
        isAuthenticated.value = false;
      }
    } catch (e) {
      debugPrint('Initial auth check error: $e');
      isAuthenticated.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    error.value = null;
    try {
      final loggedInUser = await _loginUseCase.execute(email, password);
      if (loggedInUser != null) {
        user.value = loggedInUser;
        isAuthenticated.value = true;
      } else {
        error.value = 'Login failed: Invalid credentials';
        isAuthenticated.value = false;
      }
    } catch (e) {
      if (e is DioException) {
        final message = e.response?.data?['message'] ?? e.message;
        error.value = message.toString();
      } else {
        error.value = e.toString();
      }
      isAuthenticated.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    user.value = null;
    isAuthenticated.value = false;
    error.value = null;
  }
}
