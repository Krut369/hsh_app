import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/controllers/leader_controller.dart';
import 'package:hsh_app/modules/leader/features/dashboard/leader_dashboard_screen.dart';
import 'package:hsh_app/modules/leader/features/student_results/student_results_screen.dart';
import 'package:hsh_app/modules/leader/features/leave_requests/leave_requests_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/hostel_chat_groups_screen.dart';
import 'package:hsh_app/widgets/getx_bottom_nav_bar.dart';

class LeaderMainShell extends GetView<LeaderController> {
  const LeaderMainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = const [
      LeaderDashboardScreen(),
      HostelChatGroupsScreen(),
      LeaveRequestsScreen(),
      StudentResultsScreen(),
    ];

    final navItems = [
      const GetXBottomNavBarItemData(icon: Icons.dashboard, label: 'Dashboard'),
      const GetXBottomNavBarItemData(icon: Icons.chat_bubble, label: 'Chats'),
      const GetXBottomNavBarItemData(
          icon: Icons.calendar_today, label: 'Requests'),
      const GetXBottomNavBarItemData(
          icon: Icons.person,
          label: 'Results'), // Changed label to match content
    ];

    return Scaffold(
      body: Obx(() =>
          IndexedStack(index: controller.tabIndex.value, children: screens)),
      bottomNavigationBar: Obx(() => GetXBottomNavBar(
            items: navItems,
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTab,
          )),
    );
  }
}
