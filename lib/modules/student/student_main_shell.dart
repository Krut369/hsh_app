import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import '../../../core/constants/app_text.dart';
import 'presentation/controllers/student_main_controller.dart';
import 'features/profile/bindings/profile_binding.dart';
import 'package:hsh_app/modules/complain/presentation/bindings/complain_binding.dart';
import 'package:hsh_app/modules/laundry/presentation/bindings/laundry_binding.dart';
import 'features/attendance/bindings/attendance_binding.dart';

class StudentMainShell extends StatelessWidget {
  const StudentMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentMainController());
    ProfileBinding().dependencies();
    ComplainBinding().dependencies();
    LaundryBinding().dependencies();
    AttendanceBinding().dependencies();

    final studentNavItems = [
      const ui.SimpleBottomBarItem(
        icon: Icons.person_outline,
        // activeIcon: Icons.person,
        label: AppText.profile,
      ),
      const ui.SimpleBottomBarItem(
        icon: Icons.warning_amber_rounded,
        // activeIcon: Icons.warning_rounded,
        label: AppText.complaint,
      ),
      const ui.SimpleBottomBarItem(
        icon: Icons.local_laundry_service_outlined,
        // activeIcon: Icons.local_laundry_service,
        label: 'Laundry',
      ),
      const ui.SimpleBottomBarItem(
        icon: Icons.check_circle_outline,
        // activeIcon: Icons.check_circle,
        label: AppText.attendance,
      ),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          )),
      bottomNavigationBar: SafeArea(
        child: Obx(() => ui.SimpleBottomBar(
          selectedIndex: controller.currentIndex.value,
              items: studentNavItems,

              onTap: controller.changePage,
              // horizontalMargin: 20,
              // onChanged: ,
            )),
      ),
    );
  }
}
