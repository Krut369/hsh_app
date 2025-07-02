import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/font.dart';
import '../core/utils/responsive_util.dart';
import '../providers/bottom_nav_provider.dart';
import '../core/theme/app_colors.dart';

class BottomNavBarItemData {
  final IconData icon;
  final String label;

  const BottomNavBarItemData({required this.icon, required this.label});
}

class BottomNavBar extends ConsumerWidget {
  final List<BottomNavBarItemData> items;

  const BottomNavBar({super.key, required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(bottomNavIndexProvider);
    final notifier = ref.read(bottomNavIndexProvider.notifier);

    return BottomNavigationBar(
      currentIndex: index,
      onTap: (i) => notifier.state = i,
      type: BottomNavigationBarType.fixed,

      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,

      selectedLabelStyle: AppFonts.bodyBold(context),
      unselectedLabelStyle: AppFonts.bodyRegular(context),

      selectedIconTheme: IconThemeData(
        color: AppColors.primary,
        size: ResponsiveUtil.responsiveFontSize(context, 22),
      ),
      unselectedIconTheme: IconThemeData(
        color: Colors.grey,
        size: ResponsiveUtil.responsiveFontSize(context, 20),
      ),

      items: items.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.label,
      )).toList(),
    );
  }
}
