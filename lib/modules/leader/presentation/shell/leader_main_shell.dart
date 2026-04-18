import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'controllers/shell_controller.dart';
import '../../features/dashboard/presentation/screens/leader_dashboard_screen.dart';
import '../../features/student_results/presentation/screens/student_results_screen.dart';
import '../../features/leave_requests/presentation/screens/leave_requests_screen.dart';
import '../../features/chat/presentation/screens/hostel_chat_groups_screen.dart';

@RoutePage(name: 'LeaderMainShellRoute')
class LeaderMainShell extends GetView<LeaderShellController> {
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
