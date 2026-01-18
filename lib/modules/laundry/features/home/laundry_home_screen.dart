import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/laundry_order_model.dart';
import '../../../../providers/laundry_order_provider.dart';
import '../../../laundry/controllers/laundry_filter_provider.dart';
import '../../../../providers/bottom_nav_provider.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../providers/auth_provider.dart';

import 'widgets/stat_card_widget.dart';
import 'widgets/total_requests_card.dart';
import 'widgets/quick_action_button.dart';

class LaundryHomeScreen extends ConsumerWidget {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ResponsiveUtil.responsivePadding(context);
    final orders = ref.watch(laundryOrderListProvider);

    // Calculate stats
    final totalRequests = orders.length;
    final pendingPickups = orders.where((o) => o.status == OrderStatus.inProgress).length;
    final completedCount = orders.where((o) => o.status == OrderStatus.completed).length;

    // Using specific colors
    const successGreen = Color(0xFF10B981);
    const warningOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Laundry',
        showNotificationIcon: true,
        showLogoutIcon: true,
        onLogoutTap: () {
          ref.read(authProvider.notifier).logout();
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Section Header
            Text(
              'OVERVIEW',
              style: AppFonts.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Total Requests Card
            TotalRequestsCard(count: totalRequests.toString()),
            const SizedBox(height: 16),

            // Row of Stats
            Row(
              children: [
                Expanded(
                  child: StatCardWidget(
                    title: 'Pending Pickups',
                    value: pendingPickups.toString(),
                    icon: Icons.pending_actions,
                    iconColor: warningOrange,
                    iconBg: const Color(0xFFFFF3E0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCardWidget(
                    title: 'Delivered',
                    value: completedCount.toString(),
                    icon: Icons.local_shipping,
                    iconColor: successGreen,
                    iconBg: const Color(0xFFE8F5E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: AppFonts.heading3(context).copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // View All Requests Button
            QuickActionButton(
              title: 'View All Requests',
              icon: Icons.list,
              onPressed: () {
                ref.read(laundryFilterProvider.notifier).state = 'All';
                ref.read(bottomNavIndexProvider.notifier).state = 1; // Switch to Detail Tab
              },
              isPrimary: true,
            ),
            const SizedBox(height: 12),

            // Pending Pickups Button
            QuickActionButton(
              title: 'Pending Pickups',
              icon: Icons.access_time,
              onPressed: () {
                 ref.read(laundryFilterProvider.notifier).state = 'Ready for Pickup';
                 ref.read(bottomNavIndexProvider.notifier).state = 1; // Switch to Detail Tab
              },
              isPrimary: false,
              badgeCount: pendingPickups > 0 ? pendingPickups.toString() : null,
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

