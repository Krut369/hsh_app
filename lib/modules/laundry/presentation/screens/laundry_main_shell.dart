import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';

import 'package:hsh_app/modules/laundry/presentation/screens/management/cost_management_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/orders/laundry_detail_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/home/laundry_home_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';

class LaundryMainShell extends GetView<LaundryController> {
  const LaundryMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = const [
      LaundryHomeScreen(),
      LaundryDetailScreen(),
      CostManagementScreen(),
    ];

    return Obx(() {
      final safeIndex = controller.tabIndex.value.clamp(0, screens.length - 1);
      return ModernScaffold(
        body: IndexedStack(index: safeIndex, children: screens),
        bottomNavigationBar: ModernBottomNav(
          currentIndex: safeIndex,
          onChanged: (index) => controller.changeTab(index),
          items: const [
            ModernNavItem(icon: Icons.home_outlined, activeIcon: Icons.home),
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
      );
    });
  }
}
