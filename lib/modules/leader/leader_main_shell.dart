import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/custom_bottom_nav_bar.dart';
import 'features/dashboard/leader_dashboard_screen.dart';
import 'features/student_results/student_results_screen.dart';
import 'features/leave_requests/leave_requests_screen.dart';
import 'features/chat/hostel_chat_groups_screen.dart';

final leaderBottomNavIndexProvider = StateProvider<int>((ref) => 0);

class LeaderMainShell extends ConsumerWidget {
  const LeaderMainShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(leaderBottomNavIndexProvider);

    final screens = const [
      LeaderDashboardScreen(),
      HostelChatGroupsScreen(),
      LeaveRequestsScreen(),
      StudentResultsScreen(),
    ];

    final navItems = [
      const BottomNavBarItemData(icon: Icons.dashboard, label: 'Dashboard'),
      const BottomNavBarItemData(icon: Icons.chat_bubble, label: 'Chats'),
      const BottomNavBarItemData(icon: Icons.calendar_today, label: 'Requests'),
      const BottomNavBarItemData(icon: Icons.person, label: 'Profile'),
    ];

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavBar(
        items: navItems,
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(leaderBottomNavIndexProvider.notifier).state = index;
        },
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final List<BottomNavBarItemData> items;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2D507B),
      unselectedItemColor: Colors.grey,
      items: items
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ))
          .toList(),
    );
  }
}
