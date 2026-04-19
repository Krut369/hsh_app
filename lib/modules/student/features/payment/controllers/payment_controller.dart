import 'package:get/get.dart';
import 'package:hsh_app/models/payment_model.dart';
import '../data/sources/payment_service.dart';

class PaymentController extends GetxController {
  final PaymentService _service;
  PaymentController(this._service);

  final paymentData = Rx<PaymentData>(PaymentData.initial());
  final isLoading = false.obs;
  final paymentHistory = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPaymentHistory();
  }

  Future<void> fetchPaymentHistory() async {
    isLoading.value = true;
    try {
      final response = await _service.getPaymentHistory();
      if (response.success) {
        if (response.data is List) {
          paymentHistory.value = response.data;
        }
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitPaymentProof({
    required double amount,
    required String type,
    required String screenshotPath,
    String? remark,
  }) async {
    isLoading.value = true;
    try {
      // In a real app, we would upload the screenshot first
      final response = await _service.initiatePayment(
        amount: amount,
        type: type,
        remark: remark,
      );
      
      if (response.success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Payment proof submitted for verification',
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchPaymentHistory();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to submit payment proof',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
