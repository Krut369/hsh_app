import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/presentation/screens/dashboard/complain_home_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complain_admin_screen.dart';
import 'package:hsh_app/widgets/getx_bottom_nav_bar.dart';

class ComplainMainShell extends GetView<ComplainController> {
  const ComplainMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = const [
      ComplainHomeScreen(),
      ComplaintAdminScreen(),
    ];

    final navItems = [
      const GetXBottomNavBarItemData(icon: Icons.home, label: 'Home'),
      const GetXBottomNavBarItemData(
          icon: Icons.assignment_late, label: 'Management'),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => GetXBottomNavBar(
            items: navItems,
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}
