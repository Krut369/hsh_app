import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/features/dashboard/presentation/controllers/leader_dashboard_controller.dart';
import 'package:hsh_app/modules/leader/presentation/router/leader_auto_router.dart';
import 'package:intl/intl.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/core/theme/app_colors.dart' as hsh;
import '../widgets/dashboard_feature_card.dart';

@RoutePage()
class LeaderDashboardScreen extends GetView<LeaderDashboardController> {
  const LeaderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hsh.AppColors.background,
      appBar: ModernAppBar(
        title: 'Hostel Management',
        barHeight: 70,
        actions: [
          // Notification icon with badge
          GestureDetector(
            onTap: () {},
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Logout icon
          GestureDetector(
            onTap: () => Get.find<AuthController>().logout(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Quick Overview header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ModernText(
                  'Quick Overview',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: hsh.AppColors.textPrimary,
                ),
                ModernText(
                  DateFormat('MMM dd, yyyy')
                      .format(DateTime.now())
                      .toUpperCase(),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: hsh.AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── 2×2 Feature Grid ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.0,
              children: [
                // Attendance – LIVE badge (dark navy)
                DashboardFeatureCard(
                  icon: Icons.qr_code_scanner,
                  iconColor: hsh.AppColors.primary,
                  title: 'ATTENDANCE',
                  value: '124',
                  valueSuffix: '/ 150',
                  badge: 'LIVE',
                  badgeColor: hsh.AppColors.primary,
                  onTap: () => context.router.push(const AttendanceMainRoute()),
                ),

                // Holidays – 5 PENDING badge (orange)
                DashboardFeatureCard(
                  icon: Icons.calendar_month_outlined,
                  iconColor: hsh.AppColors.warningOrange,
                  title: 'HOLIDAYS',
                  actionLabel: 'Details',
                  badge: '5 PENDING',
                  badgeColor: hsh.AppColors.warningOrange,
                  onTap: () => context.router.push(const LeaveRequestsRoute()),
                ),

                // Results – Analytics link
                DashboardFeatureCard(
                  icon: Icons.sync_alt_rounded,
                  iconColor: hsh.AppColors.primary,
                  title: 'RESULTS',
                  actionLabel: 'Analytics',
                  onTap: () => context.router.push(const StudentResultsRoute()),
                ),

                // Group Chat – 3 NEW badge (pink)
                DashboardFeatureCard(
                  icon: Icons.mark_chat_unread_outlined,
                  iconColor: const Color(0xFFE53E6A),
                  title: 'GROUP CHAT',
                  actionLabel: 'Open',
                  badge: '3 NEW',
                  badgeColor: const Color(0xFFE53E6A),
                  hasNotificationDot: true,
                  onTap: () =>
                      context.router.push(const HostelChatGroupsRoute()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
