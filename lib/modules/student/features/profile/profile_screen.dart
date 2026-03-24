import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/modules/student/features/profile/controllers/profile_controller.dart';
import 'package:hsh_app/modules/student/features/profile/profile_card.dart';
import 'package:hsh_app/modules/student/features/common/quick_action_card.dart';
import 'package:hsh_app/modules/student/features/common/activity_tile.dart';

import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:uitoolkit/uitoolkit.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtil.responsivePadding(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppText.hostelHub,
        showLogoutIcon: true,
        onLogoutTap: () {
          Get.find<AuthController>().logout();
          context.go('/login');
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card (Reverted to simple style)
            Center(
              child: Obx(
                () => ProfileCard(
                  profile: controller.profile.value,
                ),
              ),
            ),
            SizedBox(height: vertical * 2),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.quickActions,
                  style: AppFonts.heading3(context),
                ),
                TextButton(
                  onPressed: () {
                    context.push('/student/services-all');
                  },
                  child: const Text(
                    AppText.viewAll,
                    style: TextStyle(
                        color: Colors
                            .blue), // Theme primary color might be better but blue was requested
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [

                  SizedBox(
                    child: ModernStatCard(
                      layout: StatCardLayout.metric,
                      title: AppText.viewStatus,
                      icon: Icons.person_outline,
                      accentColor: Colors.blue,
                      onTap: () {
                        context.go('/student/attendance');
                      },
                      value: AppText.attendance,
                    ),
                    width: 110,
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      layout: StatCardLayout.metric,
                      icon: Icons.payments_outlined,
                      title: AppText.payDue,
                      value: AppText.fees,
                      accentColor: Colors.green,

                      onTap: () {
                        context.push('/student/payment');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      icon: Icons.warning_amber_rounded,
                      title: AppText.raiseTicket,
                      value: AppText.complaint,
                      accentColor: Colors.orange,
                      layout: StatCardLayout.metric,
                      onTap: () {
                        context.push('/student/complaint');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      layout: StatCardLayout.metric,
                      icon: Icons.chat_bubble_outline,
                      title: AppText.checkMessages,
                      value: AppText.chat,
                      accentColor: Colors.purple,
                      onTap: () {
                        context.push('/student/chat');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      icon: Icons.note_alt_outlined,
                      title: AppText.keepNotes,
                      value: AppText.notes,
                      accentColor: Colors.teal,
                      layout: StatCardLayout.metric,
                      onTap: () {
                        context.push('/student/notes');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      icon: Icons.holiday_village_outlined,
                      title: AppText.applyLeave,
                      value: AppText.holiday,
                      accentColor: Colors.pink,
                      layout: StatCardLayout.metric,
                      onTap: () {
                        context.push('/student/holiday');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: ModernStatCard(
                      icon: Icons.directions_car,
                      title: 'Register', // Short title for UI
                      value: 'Vehicle',
                      accentColor: Colors.indigo,
                      layout: StatCardLayout.metric,
                      onTap: () {
                        context.push('/student/vehicle-registration');
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: vertical * 2),

            // Recent Activity
            Text(
              AppText.recentActivity,
              style: AppFonts.heading3(context),
            ),
            const SizedBox(height: 16),
            const ActivityTile(
              icon: Icons.check_circle,
              iconColor: Colors.green,
              iconBgColor: Color(0xFFE8F5E9),
              title: AppText.feePaidSuccess,
              subtitle: 'June 12, 2024 • ${AppText.feeAmount}',
            ),
            const ActivityTile(
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              iconBgColor: Color(0xFFE3F2FD),
              title: AppText.laundryReady,
              subtitle: 'June 11, 2024 • ${AppText.laundryLoad}',
            ),
          ],
        ),
      ),
    );
  }
}
