import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:uitoolkit/uitoolkit.dart';

class ComplainHomeScreen extends GetView<ComplainController> {
  const ComplainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return ModernScaffold(
      backgroundColor: const Color(0xFFF1F6F9), // Matching image background
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
              child: Icon(Icons.exit_to_app_rounded, color: Colors.white, size: 22),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      const Text(
                        'Dashboard Overview',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D3557),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Text(
                      //   'Welcome back, Administrator',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.grey[600],
                      //     fontWeight: FontWeight.w400,
                      //   ),
                      // ),
                      const SizedBox(height: 24),

                      // Stats Grid
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'TOTAL COMPLAINTS',
                              value: stats.total.toString(),
                              icon: Icons.insert_chart_outlined_rounded,
                              iconColor: const Color(0xFF4285F4),
                              bgColor: const Color(0xFFE8F0FE),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _StatCard(
                              label: 'RESOLVED',
                              value: stats.resolved.toString(),
                              icon: Icons.check_circle_outline_rounded,
                              iconColor: const Color(0xFF34A853),
                              bgColor: const Color(0xFFE6F4EA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'PENDING',
                              value: stats.pending.toString(),
                              icon: Icons.assignment_outlined,
                              iconColor: const Color(0xFFF2994A),
                              bgColor: const Color(0xFFFDF0E3),
                            ),
                          ),
                          const Expanded(child: SizedBox()), // Placeholder for alignment
                        ],
                      ),
                      
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}


class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A869A),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1D3557),
                        height: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor,
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
          ),
        ),
      ],
    );
  }
}
