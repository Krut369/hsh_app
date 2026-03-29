import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/presentation/screens/dashboard/complain_home_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complain_admin_screen.dart';
import 'package:uitoolkit/uitoolkit.dart';

class ComplainMainShell extends GetView<ComplainController> {
  const ComplainMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = const [
      ComplainHomeScreen(),
      ComplaintAdminScreen(),
      // _ProfilePlaceholderScreen(),
    ];

    final navItems = [
      const ModernNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'HOME'),
      const ModernNavItem(
          icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'COMPLAINT'),
      // const ModernNavItem(
      //     icon: Icons.person_outline, activeIcon: Icons.person, label: 'PROFILE'),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: screens,
          )),
      bottomNavigationBar: Obx(() => ModernBottomNav(
            items: navItems,
            currentIndex: controller.tabIndex.value,
            onChanged: controller.changeTab,
          )),
    );
  }
}

// class _ProfilePlaceholderScreen extends StatelessWidget {
//   const _ProfilePlaceholderScreen();

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Profile'),
//       ),
//     );
//   }
// }
