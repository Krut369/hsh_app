import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/providers/student_profile_provider.dart';
import 'package:hsh_app/modules/student/features/profile/profile_card.dart';
import 'package:hsh_app/modules/student/features/common/quick_action_card.dart';
import 'package:hsh_app/modules/student/features/common/activity_tile.dart';

import 'package:hsh_app/widgets/custom_app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final padding = ResponsiveUtil.responsivePadding(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppText.hostelHub,
        showNotificationIcon: true,
        onNotificationTap: () {
          // Handle notification tap
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card (Reverted to simple style)
            Center(
              child: ProfileCard(
                profile: profile,
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
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.person_outline,
                      title: AppText.attendance,
                      subtitle: AppText.viewStatus,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.withOpacity(0.1),
                      onTap: () {
                        context.go('/student/attendance');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.payments_outlined,
                      title: AppText.fees,
                      subtitle: AppText.payDue,
                      iconColor: Colors.green,
                      iconBgColor: Colors.green.withOpacity(0.1),
                      onTap: () {
                        context.push('/student/payment');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.warning_amber_rounded,
                      title: AppText.complaint,
                      subtitle: AppText.raiseTicket,
                      iconColor: Colors.orange,
                      iconBgColor: Colors.orange.withOpacity(0.1),
                      onTap: () {
                        context.push('/student/complaint');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.chat_bubble_outline,
                      title: AppText.chat,
                      subtitle: AppText.checkMessages,
                      iconColor: Colors.purple,
                      iconBgColor: Colors.purple.withOpacity(0.1),
                      onTap: () {
                        context.push('/student/chat');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.note_alt_outlined,
                      title: AppText.notes,
                      subtitle: AppText.keepNotes,
                      iconColor: Colors.teal,
                      iconBgColor: Colors.teal.withOpacity(0.1),
                      onTap: () {
                        context.push('/student/notes');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.holiday_village_outlined,
                      title: AppText.holiday,
                      subtitle: AppText.applyLeave,
                      iconColor: Colors.pink,
                      iconBgColor: Colors.pink.withOpacity(0.1),
                      onTap: () {
                        context.go('/student/leave');
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
