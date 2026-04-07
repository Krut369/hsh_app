import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart' as ui;
import '../../../core/constants/app_text.dart';
import 'presentation/controllers/student_main_controller.dart';

class StudentMainShell extends StatelessWidget {
  const StudentMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentMainController());

    final studentNavItems = [
      const ui.ModernNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: AppText.profile,
      ),
      const ui.ModernNavItem(
        icon: Icons.warning_amber_rounded,
        activeIcon: Icons.warning_rounded,
        label: AppText.complaint,
      ),
      const ui.ModernNavItem(
        icon: Icons.local_laundry_service_outlined,
        activeIcon: Icons.local_laundry_service,
        label: 'Laundry',
      ),
      const ui.ModernNavItem(
        icon: Icons.check_circle_outline,
        activeIcon: Icons.check_circle,
        label: AppText.attendance,
      ),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.currentIndex.value,
            children: controller.pages,
          )),
      bottomNavigationBar: SafeArea(
        child: Obx(() => ui.ModernBottomNav(
              initialIndex: controller.currentIndex.value,
              items: studentNavItems,
              horizontalMargin: 20,
              onChanged: controller.changePage,
            )),
      ),
    );
  }
}
