import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/controllers/leader_controller.dart';

class LeaderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaderController>(() => LeaderController());
  }
}
