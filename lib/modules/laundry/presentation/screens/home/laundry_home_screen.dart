import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';

import 'package:hsh_app/modules/laundry/presentation/widgets/home/stat_card_widget.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/total_requests_card.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/quick_action_button.dart';

class LaundryHomeScreen extends GetView<LaundryController> {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtil.responsivePadding(context);

    // Using specific colors
    const successGreen = Color(0xFF10B981);
    const warningOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Laundry',
        showNotificationIcon: true,
        showLogoutIcon: true,
        onLogoutTap: () async {
          await Get.find<AuthController>().logout();
        },
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = controller.orders;
        final totalRequests = orders.length;
        final pendingPickups =
            orders.where((o) => o.status == OrderStatus.inProgress).length;
        final completedCount =
            orders.where((o) => o.status == OrderStatus.completed).length;

        return SingleChildScrollView(
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
                  controller.setFilter('All');
                  controller.changeTab(1); // Switch to Orders tab
                },
                isPrimary: true,
              ),
              const SizedBox(height: 12),

              // Pending Pickups Button
              QuickActionButton(
                title: 'Pending Pickups',
                icon: Icons.access_time,
                onPressed: () {
                  controller.setFilter('Ready for Pickup');
                  controller.changeTab(1); // Switch to Orders tab
                },
                isPrimary: false,
                badgeCount:
                    pendingPickups > 0 ? pendingPickups.toString() : null,
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}
