import 'package:get/get.dart';
import '../../features/holiday/controllers/holiday_controller.dart';
import '../../features/holiday/data/sources/holiday_service.dart';
import '../../features/payment/controllers/payment_controller.dart';
import '../../features/payment/data/sources/payment_service.dart';
import 'package:hsh_app/core/network/api_client.dart';

class StudentBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize required services if not already present
    // Note: Assuming ApiClient is globally available or provided elsewhere, otherwise we dummy it or put it.
    if (!Get.isRegistered<ApiClient>()) {
      Get.lazyPut(() => ApiClient());
    }

    // Holiday Dependencies
    Get.lazyPut(() => HolidayService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut(() => HolidayController(Get.find<HolidayService>()), fenix: true);

    // Payment Dependencies
    Get.lazyPut(() => PaymentService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut(() => PaymentController(Get.find<PaymentService>()), fenix: true);
  }
}
