import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/constants/font.dart';
import '../core/utils/responsive_util.dart';
import '../providers/bottom_nav_provider.dart';
import '../core/theme/app_colors.dart';

class BottomNavBarItemData {
  final IconData icon;
  final String label;

  const BottomNavBarItemData({required this.icon, required this.label});
}

class BottomNavBar extends StatelessWidget {
  final List<BottomNavBarItemData> items;

  const BottomNavBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // If you haven't registered this controller in main, you can Get.put it here,
    // but better to have it in a binding or main initialization.
    // For safety, we use Get.isRegistered or just Get.put if not found.
    final controller = Get.isRegistered<BottomNavController>()
        ? Get.find<BottomNavController>()
        : Get.put(BottomNavController());

    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (i) => controller.changeIndex(i),
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
        ));
  }
}
