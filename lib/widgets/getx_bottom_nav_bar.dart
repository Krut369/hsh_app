import 'package:flutter/material.dart';
import '../core/constants/font.dart';
import '../core/utils/responsive_util.dart';
import '../core/theme/app_colors.dart';

class GetXBottomNavBarItemData {
  final IconData icon;
  final String label;

  const GetXBottomNavBarItemData({required this.icon, required this.label});
}

class GetXBottomNavBar extends StatelessWidget {
  final List<GetXBottomNavBarItemData> items;
  final int currentIndex;
  final Function(int) onTap;

  const GetXBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon, size: 28),
                label: item.label,
              ))
          .toList(),
    );
  }
}
