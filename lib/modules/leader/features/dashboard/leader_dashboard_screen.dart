import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../leader_main_shell.dart';
import 'widgets/feature_card.dart';
import 'widgets/system_status_widget.dart';
import '../../../../widgets/custom_app_bar.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class LeaderDashboardScreen extends ConsumerWidget {
  const LeaderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: CustomAppBar(
        title: 'Dashboard', // Fallback title
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hostel Management',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'ADMIN PORTAL',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.calendar_today, color: Colors.white, size: 24),
          ),
        ),
        showNotificationIcon: true,
        showLogoutIcon: true,
        onLogoutTap: () {
          Get.find<AuthController>().logout();
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location Selector
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF4A6FA5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'St. Jude Block - Sector A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),

            // Quick Overview Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Quick Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D507B),
                    ),
                  ),
                  Text(
                    DateFormat('MMM dd, yyyy').format(DateTime.now()),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5D90B3),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Feature Cards Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  FeatureCard(
                    icon: Icons.qr_code_scanner,
                    iconColor: const Color(0xFF2D507B),
                    title: 'ATTENDANCE',
                    value: '124',
                    subtitle: '/ 150',
                    badge: 'LIVE',
                    badgeColor: const Color(0xFF2D507B),
                    onTap: () => context.push('/leader/attendance'),
                  ),
                  FeatureCard(
                    icon: Icons.calendar_month,
                    iconColor: Colors.orange,
                    title: 'HOLIDAY REQUESTS',
                    badge: '5 Pending',
                    badgeColor: Colors.orange,
                    onTap: () {
                      ref.read(leaderBottomNavIndexProvider.notifier).state = 2;
                    },
                  ),
                  FeatureCard(
                    icon: Icons.emoji_events,
                    iconColor: const Color(0xFF2D507B),
                    title: 'STUDENT RESULTS',
                    subtitle: 'View Analytics →',
                    onTap: () {
                      ref.read(leaderBottomNavIndexProvider.notifier).state = 3;
                    },
                  ),
                  FeatureCard(
                    icon: Icons.chat_bubble,
                    iconColor: Colors.pink,
                    title: 'HOSTEL GROUP',
                    badge: '3 New Messages',
                    badgeColor: Colors.pink,
                    hasNotification: true,
                    onTap: () {
                      ref.read(leaderBottomNavIndexProvider.notifier).state = 1;
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // System Status
            const SystemStatusWidget(),
          ],
        ),
      ),
    );
  }
}
