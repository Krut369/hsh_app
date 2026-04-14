import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import 'package:hsh_app/modules/laundry/presentation/screens/management/cost_management_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/orders/laundry_detail_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/home/laundry_home_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';

class LaundryMainShell extends StatefulWidget {
  const LaundryMainShell({super.key});

  @override
  State<LaundryMainShell> createState() => _LaundryMainShellState();
}

class _LaundryMainShellState extends State<LaundryMainShell> {
  final LaundryController controller = Get.find<LaundryController>();
  bool _isBottomNavVisible = true;

  final screens = const [
    LaundryHomeScreen(),
    LaundryDetailScreen(),
    CostManagementScreen(),
  ];

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse &&
          _isBottomNavVisible) {
        setState(() => _isBottomNavVisible = false);
      } else if (notification.direction == ScrollDirection.forward &&
          !_isBottomNavVisible) {
        setState(() => _isBottomNavVisible = true);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final safeIndex = controller.tabIndex.value.clamp(0, screens.length - 1);
      return Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: NotificationListener<ScrollNotification>(
          onNotification: _handleScrollNotification,
          child: IndexedStack(index: safeIndex, children: screens),
        ),
        bottomNavigationBar: AnimatedSlide(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          offset: _isBottomNavVisible ? Offset.zero : const Offset(0, 1.5),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isBottomNavVisible ? 1.0 : 0.0,
            child: ModernBottomNav(
              currentIndex: safeIndex,
              onChanged: (index) => controller.changeTab(index),
              items: const [
                ModernNavItem(
                    icon: Icons.home_outlined, activeIcon: Icons.home),
                ModernNavItem(
                  icon: Icons.local_laundry_service_outlined,
                  activeIcon: Icons.local_laundry_service,
                ),
                ModernNavItem(
                  icon: Icons.attach_money_outlined,
                  activeIcon: Icons.attach_money,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
