import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_text.dart';
import '../../providers/bottom_nav_provider.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import 'features/dashboard/complain_home_screen.dart';
import 'features/feedback/complain_feedback_screen.dart';
import 'features/management/complain_admin_screen.dart';


class ComplainMainShell extends ConsumerWidget {
  const ComplainMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);

    final screens = const [
      ComplainHomeScreen(),
      ComplaintAdminScreen(),
      // ComplainFeedbackScreen()
    ];

    final studentNavItems = [
      const BottomNavBarItemData(icon: Icons.home, label: AppText.home),
      const BottomNavBarItemData(icon: Icons.settings_input_component_sharp, label: AppText.complaint),
      // const BottomNavBarItemData(icon: Icons.feedback_rounded, label: AppText.attendance),

    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: BottomNavBar(items: studentNavItems),
    );
  }
}
