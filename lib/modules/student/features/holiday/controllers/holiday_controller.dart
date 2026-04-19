import 'package:get/get.dart';
import '../data/sources/holiday_service.dart';
import 'package:hsh_app/models/leave_request_model.dart';

class HolidayController extends GetxController {
  final HolidayService _service;
  HolidayController(this._service);

  final holidays = <LeaveRequest>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHolidays();
  }

  Future<void> fetchHolidays() async {
    isLoading.value = true;
    try {
      final response = await _service.getHolidayRequests();
      if (response.success) {
        if (response.data is List) {
          holidays.value = (response.data as List)
              .map((e) => LeaveRequest.fromMap(e as Map<String, dynamic>))
              .toList();
        }
      } else {
        // Fallback for demo if API fails
        _loadDemoData();
      }
    } catch (e) {
      _loadDemoData();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadDemoData() {
    // Adding some demo data if API is not available or fails
    if (holidays.isEmpty) {
      holidays.value = [
        LeaveRequest(
          id: '1',
          startDate: DateTime.now().add(const Duration(days: 2)),
          endDate: DateTime.now().add(const Duration(days: 5)),
          reason: 'Going home for wedding',
          status: LeaveStatus.pending,
          leaveType: 'Personal',
          studentId: 'stud_1',
          studentName: 'John Doe',
          studentAvatar: 'https://i.pravatar.cc/300',
          room: '101',
          appliedAt: DateTime.now(),
        ),
      ];
    }
  }

  Future<void> submitHolidayRequest({
    required String startDate,
    required String endDate,
    required String reason,
    String? destination,
  }) async {
    isLoading.value = true;
    try {
      final response = await _service.createHolidayRequest(
        startDate: startDate,
        endDate: endDate,
        reason: reason,
        destination: destination,
      );
      if (response.success) {
        Get.back();
        Get.snackbar(
          'Success',
          'Holiday request submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        fetchHolidays();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Failed to submit request',
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
