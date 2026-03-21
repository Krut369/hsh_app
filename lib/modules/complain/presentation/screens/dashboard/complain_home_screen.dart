import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/presentation/widgets/dashboard/stat_card_widget.dart';

class ComplainHomeScreen extends GetView<ComplainController> {
  const ComplainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        elevation: 0,
        title: const Text(
          'Complaint Manager',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => authController.logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.stats.value.total == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        final stats = controller.stats.value;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dashboard Overview Section
              Container(
                width: double.infinity,
                color: AppColors.background,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dashboard Overview',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome back, Administrator',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Stat Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    StatCardWidget(
                      title: 'TOTAL COMPLAINTS',
                      value: stats.total.toString(),
                      percentage: '',
                      isPositive: true,
                      icon: Icons.bar_chart,
                      borderColor: const Color(0xFF2196F3),
                      iconColor: const Color(0xFF2196F3),
                    ),
                    StatCardWidget(
                      title: 'PENDING',
                      value: stats.pending.toString(),
                      percentage: '',
                      isPositive: true,
                      icon: Icons.pending_actions,
                      borderColor: const Color(0xFFFF9800),
                      iconColor: const Color(0xFFFF9800),
                    ),
                    StatCardWidget(
                      title: 'RESOLVED',
                      value: stats.resolved.toString(),
                      percentage: '',
                      isPositive: false,
                      icon: Icons.check_circle_outline,
                      borderColor: const Color(0xFF4CAF50),
                      iconColor: const Color(0xFF4CAF50),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      }),
    );
  }
}
