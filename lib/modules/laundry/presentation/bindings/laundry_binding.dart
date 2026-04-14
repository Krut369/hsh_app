import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hsh_app/modules/laundry/data/repositories/laundry_repository_impl.dart';
import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/modules/laundry/data/sources/laundry_local_data_source.dart';
import 'package:hsh_app/modules/laundry/data/sources/laundry_remote_data_source.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/get_laundry_orders_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/update_order_status_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/create_laundry_order_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/manage_laundry_cost_usecase.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';

class LaundryBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Sources
    Get.lazyPut(() => LaundryRemoteDataSource(), fenix: true);
    Get.lazyPut(() => LaundryLocalDataSource(Get.find<SharedPreferences>()), fenix: true);

    // 2. Repository
    Get.lazyPut(() => LaundryRepositoryImpl(
          Get.find<LaundryRemoteDataSource>(),
          Get.find<LaundryLocalDataSource>(),
        ), fenix: true);

    // 3. Usecases
    Get.lazyPut(
        () => GetLaundryOrdersUseCase(Get.find<LaundryRepositoryImpl>()), fenix: true);
    Get.lazyPut(
        () => UpdateOrderStatusUseCase(Get.find<LaundryRepositoryImpl>()), fenix: true);
    Get.lazyPut(
        () => CreateLaundryOrderUseCase(Get.find<LaundryRepositoryImpl>()), fenix: true);
    Get.lazyPut(
        () => ManageLaundryCostUseCase(Get.find<LaundryRepositoryImpl>()), fenix: true);

    // 4. Controller (Lazy for better resource management)
    Get.lazyPut(() => LaundryController(
          getOrdersUseCase: Get.find<GetLaundryOrdersUseCase>(),
          updateStatusUseCase: Get.find<UpdateOrderStatusUseCase>(),
          createOrderUseCase: Get.find<CreateLaundryOrderUseCase>(),
          costUseCase: Get.find<ManageLaundryCostUseCase>(),
        ), fenix: true);
  }
}
