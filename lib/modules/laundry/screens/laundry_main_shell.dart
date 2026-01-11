import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../../providers/bottom_nav_provider.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';
import 'laundry_detail_screen.dart';
import 'laundry_home_screen.dart';
import 'laundry_message_screen.dart';


class LaundryMainShell extends ConsumerWidget {
  const LaundryMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      LaundryHomeScreen(),
      LaundryDetailScreen(),
      LaundryMessageScreen()
    ];

    final studentNavItems = [
      const BottomNavBarItemData(icon: Icons.home, label: AppText.home),
      const BottomNavBarItemData(icon: Icons.local_laundry_service_outlined, label: AppText.laundry),
      const BottomNavBarItemData(icon: Icons.feedback_rounded, label: AppText.message),

    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(items: studentNavItems),
    );
  }
}
