import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/student/presentation/controllers/student_main_controller.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/modules/student/features/profile/controllers/profile_controller.dart';
import 'package:hsh_app/modules/student/features/profile/profile_card.dart';
import 'package:hsh_app/modules/student/features/common/activity_tile.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const double padding = 20.0;

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Premium Navy Header (Background Layer)
                _buildHeader(context),

                // Premium ID Card (Floating Layer)
                Positioned(
                  top: MediaQuery.of(context).padding.top +
                      100, // Sits perfectly below title
                  left: padding,
                  right: padding,
                  child: Obx(
                    () => ProfileCard(
                      profile: controller.profile.value,
                    ),
                  ),
                ),
              ],
            ),

            // Add spacing to account for the floating card's height
            const SizedBox(height: 70),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ModernText(
                        AppText.quickActions,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headerBlue,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.toNamed('/student/services-all');
                        },
                        child: const Text(
                          AppText.viewAll,
                          style: TextStyle(
                              color: Color(0xFF3B82F6),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStatCard(
                          title: 'View Status',
                          icon: Icons.person_outline,
                          accentColor: Colors.blue,
                          onTap: () =>
                              Get.find<StudentMainController>().changePage(3),
                          value: 'Attendance',
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.payments_outlined,
                          title: 'Pay Due',
                          value: 'Fees',
                          accentColor: Colors.green,
                          onTap: () => Get.toNamed('/student/payment'),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.warning_amber_rounded,
                          title: 'Raise Ticket',
                          value: 'Complaint',
                          accentColor: Colors.orange,
                          onTap: () =>
                              Get.find<StudentMainController>().changePage(1),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.chat_bubble_outline,
                          title: 'Check',
                          value: 'Chat',
                          accentColor: Colors.purple,
                          onTap: () => Get.toNamed('/student/chat'),
                        ),
                        const SizedBox(width: 12),
                        _buildStatCard(
                          icon: Icons.holiday_village_outlined,
                          title: 'Apply',
                          value: 'Holiday',
                          accentColor: Colors.pink,
                          onTap: () => Get.toNamed('/student/holiday'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Recent Activity
                  // const ModernText(
                  //   AppText.recentActivity,
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.bold,
                  //   color: AppColors.headerBlue,
                  // ),
                  // const SizedBox(height: 16),
                  // const ActivityTile(
                  //   icon: Icons.check_circle_rounded,
                  //   iconColor: Colors.green,
                  //   iconBgColor: Color(0xFFECFDF5),
                  //   title: AppText.feePaidSuccess,
                  //   subtitle: 'June 12, 2024 • ${AppText.feeAmount}',
                  // ),
                  // const SizedBox(height: 12),
                  // const ActivityTile(
                  //   icon: Icons.local_laundry_service_rounded,
                  //   iconColor: Colors.blue,
                  //   iconBgColor: Color(0xFFEFF6FF),
                  //   title: AppText.laundryReady,
                  //   subtitle: 'June 11, 2024 • ${AppText.laundryLoad}',
                  // ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 290, // Deeper to go behind the card
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48),
          bottomRight: Radius.circular(48),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start, // Title stays at the top
        children: [
          const Text(
            'HARI-SAURABH',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, // Slightly larger
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2, // More spread out like the mockup
              fontFamily:
                  'Inter', // Using standard Inter if available, or just bold sans
            ),
          ),
          Row(
            children: [
              _buildHeaderAction(Icons.notifications_none_rounded, () {}),
              const SizedBox(width: 12),
              _buildHeaderAction(Icons.logout_rounded, () {
                Get.find<AuthController>().logout();
                Get.offAllNamed('/login');
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required IconData icon,
    required Color accentColor,
    required VoidCallback onTap,
    required String value,
  }) {
    return SizedBox(
      width: 120,
      child: ModernStatCard(
        layout: StatCardLayout.metric,
        title: title,
        icon: icon,
        accentColor: accentColor,
        onTap: onTap,
        value: value,
      ),
    );
  }
}
