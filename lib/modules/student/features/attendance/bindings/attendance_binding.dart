import 'package:get/get.dart';
import 'package:hsh_app/core/network/api_client.dart';
import '../controllers/attendance_controller.dart';
import '../data/sources/attendance_service.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AttendanceService(Get.find<ApiClient>()));
    Get.lazyPut(() => AttendanceController());
  }
}
