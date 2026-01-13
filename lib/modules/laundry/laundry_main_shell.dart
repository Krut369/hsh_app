import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_text.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'features/orders/laundry_detail_screen.dart';
import 'features/home/laundry_home_screen.dart';
import 'features/chat/laundry_chat_screen.dart';
import 'features/management/cost_management_screen.dart';


class LaundryMainShell extends ConsumerWidget {
  const LaundryMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      LaundryHomeScreen(),
      LaundryDetailScreen(),
      CostManagementScreen(),
      LaundryChatScreen(),
    ];

    final studentNavItems = [
      const BottomNavBarItemData(icon: Icons.home, label: AppText.home),
      const BottomNavBarItemData(icon: Icons.local_laundry_service_outlined, label: AppText.laundry),
      const BottomNavBarItemData(icon: Icons.attach_money, label: "Costs"),
      const BottomNavBarItemData(icon: Icons.chat_bubble_outline, label: "Messages"),

    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(items: studentNavItems),
    );
  }
}
