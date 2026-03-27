import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';

class LaundryHomeScreen extends GetView<LaundryController> {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtil.responsivePadding(context);

    // Using specific colors
    const successGreen = Color(0xFF10B981);
    const warningOrange = Color(0xFFF59E0B);

    return ModernScaffold(
      title: 'Laundry',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await Get.find<AuthController>().logout();
          },
        ),
      ],
      body: Obx(() {
        if (controller.isLoading.value && controller.orders.isEmpty) {
          return const Center(child: ModernLoader(size: 40));
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
              const ModernText(
                'OVERVIEW',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              const SizedBox(height: 16),

              // Total Requests Card
              ModernStatCard(
                layout: StatCardLayout.horizontal,
                title: 'TOTAL REQUESTS',
                value: totalRequests.toString(),
                icon: Icons.local_laundry_service_rounded,
                accentColor: AppColors.primary,
              ),
              const SizedBox(height: 16),

              // Row of Stats
              Row(
                children: [
                  Expanded(
                    child: ModernStatCard(
                      layout: StatCardLayout.iconTop,
                      title: 'Pending Pickups',
                      value: pendingPickups.toString(),
                      icon: Icons.pending_actions,
                      accentColor: warningOrange,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ModernStatCard(
                      layout: StatCardLayout.iconTop,
                      title: 'Delivered',
                      value: completedCount.toString(),
                      icon: Icons.local_shipping,
                      accentColor: successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions Section
              const ModernText(
                'Quick Actions',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 16),

              // View All Requests Button
              ModernListTile(
                title: 'View All Requests',
                leading: const Icon(Icons.list, color: AppColors.primary),
                onTap: () {
                  controller.setFilter('All');
                  controller.changeTab(1); // Switch to Orders tab
                },
              ),

              // Pending Pickups Button
              ModernListTile(
                title: 'Pending Pickups',
                leading: Icon(Icons.access_time, color: warningOrange),
                trailing: pendingPickups > 0
                    ? ModernBadge(
                        text: pendingPickups.toString(),
                        type: BadgeType.warning,
                      )
                    : null,
                onTap: () {
                  controller.setFilter('Ready for Pickup');
                  controller.changeTab(1); // Switch to Orders tab
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        );
      }),
    );
  }
}
