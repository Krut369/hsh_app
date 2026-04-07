import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/complaint/complaint_screen.dart';
import '../../features/laundry/laundry_screen.dart';
import '../../features/attendance/attendance_screen.dart';

class StudentMainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    ProfileScreen(),
    const ComplaintScreen(),
    const LaundryScreen(),
    const AttendanceScreen(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
