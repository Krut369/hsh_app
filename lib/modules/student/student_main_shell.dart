// lib/modules/student/screens/student_main_shell.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_util.dart';

import '../../../providers/bottom_nav_provider.dart';
import '../../../widgets/MoreOptionsScreen.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';

import 'package:hsh_app/modules/student/features/holiday/holiday_payment_screen.dart';
import 'package:hsh_app/modules/student/features/home/home_screen.dart';
import 'package:hsh_app/modules/student/features/attendance/attendance_screen.dart';
import 'package:hsh_app/modules/student/features/profile/profile_screen.dart';
import 'package:hsh_app/modules/student/features/services/service_manager_screen.dart';

class StudentMainShell extends ConsumerWidget {
  const StudentMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final isMoreSelected = currentIndex == 4;

    final screens = [
      ProfileScreen(),
      const ServiceManagerScreen(),
      const AttendanceScreen(),
      const HolidayPaymentScreen(),
      // const HomeScreen(), // Placeholder if "More" is tapped
    ];

    final studentNavItems = [
      const BottomNavBarItemData(icon: Icons.person, label: AppText.profile),
      const BottomNavBarItemData(icon: Icons.cleaning_services_sharp, label: AppText.service),
      const BottomNavBarItemData(icon: Icons.check_circle, label: AppText.attendance),
      const BottomNavBarItemData(icon: Icons.flight_takeoff, label: AppText.leave),
      const BottomNavBarItemData(icon: Icons.more_vert, label: 'More'),
    ];

    return Scaffold(
      body: IndexedStack(
        index: isMoreSelected ? 0 : currentIndex, // Fallback to profile screen when "More" is tapped
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == 4) {
            // Bottom sheet on "More"
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) => const MoreOptionsBottomSheet(),
            );
          } else {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          }
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppFonts.bodyMedium(context),
        unselectedLabelStyle: AppFonts.bodyRegular(context),
        items: studentNavItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon, size: ResponsiveUtil.responsiveIconSize(context, 24)),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
