import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/presentation/screens/dashboard/complain_home_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complain_admin_screen.dart';
import 'package:uitoolkit/uitoolkit.dart';

class ComplainMainShell extends StatefulWidget {
  const ComplainMainShell({super.key});

  @override
  State<ComplainMainShell> createState() => _ComplainMainShellState();
}

class _ComplainMainShellState extends State<ComplainMainShell> {
  final ComplainController controller = Get.find<ComplainController>();
  bool _isBottomNavVisible = true;

  final screens = const [
    ComplainHomeScreen(),
    ComplaintAdminScreen(),
  ];

  final navItems = const [
    ModernNavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'HOME'),
    ModernNavItem(
        icon: Icons.assignment_outlined, activeIcon: Icons.assignment, label: 'COMPLAINT'),
  ];

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse && _isBottomNavVisible) {
        setState(() => _isBottomNavVisible = false);
      } else if (notification.direction == ScrollDirection.forward && !_isBottomNavVisible) {
        setState(() => _isBottomNavVisible = true);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Obx(() => IndexedStack(
              index: controller.tabIndex.value,
              children: screens,
            )),
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        offset: _isBottomNavVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isBottomNavVisible ? 1.0 : 0.0,
          child: Obx(() => ModernBottomNav(
                items: navItems,
                currentIndex: controller.tabIndex.value,
                onChanged: controller.changeTab,
              )),
        ),
      ),
    );
  }
}
