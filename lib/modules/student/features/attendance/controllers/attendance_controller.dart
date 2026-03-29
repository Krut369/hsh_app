import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/models/attendance_record_model.dart';
import 'package:hsh_app/modules/student/features/attendance/data/sources/attendance_service.dart';

class AttendanceController extends GetxController {
  final AttendanceService _service = Get.find<AttendanceService>();

  var selectedType = Rxn<AttendanceEventType>();
  var scanCount = 0.obs;
  var isLoading = false.obs;

  final Map<AttendanceEventType, (IconData icon, Color accentColor)> eventConfig = {
    AttendanceEventType.lunch: (Icons.menu_book_rounded, const Color(0xFFD35400)),
    AttendanceEventType.dinner: (Icons.nightlight_round, const Color(0xFF2980B9)),
    AttendanceEventType.sabha: (Icons.groups_rounded, const Color(0xFF8E44AD)),
    AttendanceEventType.studyHour: (Icons.access_time_filled_rounded, const Color(0xFF27AE60)),
    AttendanceEventType.arti: (Icons.local_fire_department_rounded, const Color(0xFFC0392B)),
    AttendanceEventType.nightAttendance: (Icons.assignment_turned_in_rounded, const Color(0xFF3F51B5)),
  };

  void selectType(AttendanceEventType type) {
    selectedType.value = type;
  }

  void incrementScan() {
    if (scanCount.value < 2) {
      scanCount.value++;
    }
  }

  void resetScans() {
    scanCount.value = 0;
  }

  Future<void> fetchAttendance() async {
    isLoading.value = true;
    try {
      // Use _service if needed
      await _service.getAttendance();
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
