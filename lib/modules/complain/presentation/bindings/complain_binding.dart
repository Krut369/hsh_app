import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/data/repositories/complain_repository_impl.dart';
import 'package:hsh_app/modules/complain/domain/usecases/get_complaints_usecase.dart';
import 'package:hsh_app/modules/complain/domain/usecases/get_complaint_stats_usecase.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';

class ComplainBinding extends Bindings {
  @override
  void dependencies() {
    // 1. Repository
    Get.lazyPut<ComplainRepositoryImpl>(() => ComplainRepositoryImpl());

    // 2. Use Cases
    Get.lazyPut(() => GetComplaintsUseCase(Get.find<ComplainRepositoryImpl>()));
    Get.lazyPut(
        () => GetComplaintStatsUseCase(Get.find<ComplainRepositoryImpl>()));

    // 3. Controller
    Get.lazyPut(() => ComplainController(
          getComplaintsUseCase: Get.find<GetComplaintsUseCase>(),
          repository: Get.find<ComplainRepositoryImpl>(),
        ));
  }
}
