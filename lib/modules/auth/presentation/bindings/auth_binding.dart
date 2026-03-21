import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/sources/auth_local_data_source.dart';
import '../../data/sources/auth_api_service.dart';
import '../../data/sources/auth_remote_data_source.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Dependency Initialization
    // SharedPreferences is already initialized in main.dart

    // 2. Core API Client
    Get.lazyPut<ApiClient>(() => ApiClient());

    // AuthApiService needs Dio from ApiClient
    Get.lazyPut<AuthApiService>(
        () => AuthApiService(Get.find<ApiClient>().dio));

    // 3. Data Sources
    Get.lazyPut<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(Get.find<AuthApiService>()));

    // AuthLocalDataSource needs SharedPreferences.
    // Use Get.find<SharedPreferences>() once available.
    Get.lazyPut<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(Get.find<SharedPreferences>()));

    // 4. Repositories
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(
          Get.find<AuthRemoteDataSource>(),
          Get.find<AuthLocalDataSource>(),
        ));

    // 5. Use Case
    Get.lazyPut<LoginUseCase>(() => LoginUseCase(Get.find<AuthRepository>()));

    // 6. Controller
    Get.put<AuthController>(AuthController(
      loginUseCase: Get.find<LoginUseCase>(),
      authRepository: Get.find<AuthRepository>(),
    ));
  }
}
