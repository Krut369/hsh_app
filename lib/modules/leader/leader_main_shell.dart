import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'package:hsh_app/modules/leader/presentation/controllers/leader_controller.dart';
import 'package:hsh_app/modules/leader/features/dashboard/leader_dashboard_screen.dart';
import 'package:hsh_app/modules/leader/features/student_results/student_results_screen.dart';
import 'package:hsh_app/modules/leader/features/leave_requests/leave_requests_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/hostel_chat_groups_screen.dart';

@RoutePage(name: 'LeaderMainShellRoute')
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
      const ui.SimpleBottomBarItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
      const ui.SimpleBottomBarItem(icon: Icons.chat_bubble_outline, label: 'Chats'),
      const ui.SimpleBottomBarItem(icon: Icons.calendar_today_outlined, label: 'Requests'),
      const ui.SimpleBottomBarItem(icon: Icons.person_outline, label: 'Results'),
    ];

    return Scaffold(
      body: Obx(() =>
          IndexedStack(index: controller.tabIndex.value, children: screens)),
      bottomNavigationBar: SafeArea(
        child: Obx(() => ui.SimpleBottomBar(
              selectedIndex: controller.tabIndex.value,
              items: navItems,
              onTap: controller.changeTab,
            )),
      ),
    );
  }
}
