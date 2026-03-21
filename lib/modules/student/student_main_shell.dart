// lib/modules/student/screens/student_main_shell.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';

class StudentMainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StudentMainShell({
    required this.navigationShell,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Current index is managed by the shell
    final currentIndex = navigationShell.currentIndex;

    final studentNavItems = [
      const BottomNavBarItemData(icon: Icons.person, label: AppText.profile),
      const BottomNavBarItemData(
          icon: Icons.warning_amber_rounded, label: AppText.complaint),
      const BottomNavBarItemData(
          icon: Icons.local_laundry_service, label: 'Laundry'),
      const BottomNavBarItemData(
          icon: Icons.check_circle, label: AppText.attendance),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // Use navigationShell to switch branches
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppFonts.bodyMedium(context),
        unselectedLabelStyle: AppFonts.bodyRegular(context),
        items: studentNavItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon,
                size: ResponsiveUtil.responsiveIconSize(context, 24)),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
