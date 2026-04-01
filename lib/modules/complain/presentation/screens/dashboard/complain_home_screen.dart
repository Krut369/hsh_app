import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_colors.dart' as hsh;
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:uitoolkit/uitoolkit.dart';

class ComplainHomeScreen extends GetView<ComplainController> {
  const ComplainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return ModernScaffold(
      backgroundColor: hsh.AppColors.background,
      appBar: ModernAppBar(
        title: 'Complaint Manager',
        actions: [
          // GestureDetector(
          //   onTap: () {},
          //   behavior: HitTestBehavior.opaque,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     child: Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
          //   ),
          // ),
          GestureDetector(
            onTap: () => authController.logout(),
            behavior: HitTestBehavior.opaque,
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(Icons.logout, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stats.value.total == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = controller.stats.value;

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchComplaints(),
              controller.fetchStats(),
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dashboard Overview Title
                const Text(
                  'Dashboard Overview',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: hsh.AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                // Text(
                //   'Welcome back, Administrator',
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: Colors.grey[600],
                //   ),
                // ),
                // const SizedBox(height: 24),
                // Stat Cards Grid
                // Total Complaints - Full Width
                _StatCard(
                  title: 'TOTAL COMPLAINTS',
                  value: stats.total.toString(),
                  icon: Icons.bar_chart,
                  iconColor: const Color(0xFF2196F3),
                  borderColor: const Color(0xFFBBDEFB),
                ),
                const SizedBox(height: 16),
                // Pending + Resolved Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'PENDING',
                        value: stats.pending.toString(),
                        icon: Icons.assignment_outlined,
                        iconColor: const Color(0xFFFF9800),
                        borderColor: const Color(0xFFFFE0B2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        title: 'RESOLVED',
                        value: stats.resolved.toString(),
                        icon: Icons.check_circle_outline,
                        iconColor: const Color(0xFF26A69A),
                        borderColor: const Color(0xFFB2DFDB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Quick Actions Section
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: hsh.AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),

                ModernListTile(
                  title: 'View All Complaints',
                  leading: const Icon(Icons.list_alt, color: Color(0xFF2196F3)),
                  onTap: () {
                    controller.setFilter(null);
                    controller.changeTab(1);
                  },
                ),

                ModernListTile(
                  title: 'Pending Complaints',
                  leading: const Icon(Icons.access_time_rounded, color: Color(0xFFFF9800)),
                  trailing: stats.pending > 0
                      ? ModernBadge(
                          text: stats.pending.toString(),
                          type: BadgeType.warning,
                        )
                      : null,
                  onTap: () {
                    controller.setFilter(ComplaintStatus.pending);
                    controller.changeTab(1);
                  },
                ),

                ModernListTile(
                  title: 'Resolved Complaints',
                  leading: const Icon(Icons.check_circle_outline, color: Color(0xFF26A69A)),
                  trailing: stats.resolved > 0
                      ? ModernBadge(
                          text: stats.resolved.toString(),
                          type: BadgeType.success,
                        )
                      : null,
                  onTap: () {
                    controller.setFilter(ComplaintStatus.resolved);
                    controller.changeTab(1);
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ));
      }),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              letterSpacing: 0.3,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
