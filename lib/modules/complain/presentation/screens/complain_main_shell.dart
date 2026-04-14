import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/complain/presentation/screens/dashboard/complain_home_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complain_admin_screen.dart';

class ComplainMainShell extends StatefulWidget {
  const ComplainMainShell({super.key});

  @override
  State<ComplainMainShell> createState() => _ComplainMainShellState();
}

class _ComplainMainShellState extends State<ComplainMainShell> {
  final ComplainController controller = Get.find<ComplainController>();
  bool _isBottomNavVisible = true;

  final screens = [
    const ComplainHomeScreen(),
    const ComplaintAdminScreen(),
    // const Scaffold(body: Center(child: Text('Reports Coming Soon'))),
  ];

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.reverse && _isBottomNavVisible) {
        setState(() => _isBottomNavVisible = false);
      } else if (notification.direction == ScrollDirection.forward && !_isBottomNavVisible) {
        setState(() => _isBottomNavVisible = true);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFFF1F6F9),
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: Obx(() => IndexedStack(
              index: controller.tabIndex.value >= screens.length ? 0 : controller.tabIndex.value,
              children: screens,
            )),
      ),
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        offset: _isBottomNavVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isBottomNavVisible ? 1.0 : 0.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Obx(() => BottomNavigationBar(
              currentIndex: controller.tabIndex.value >= screens.length ? 0 : controller.tabIndex.value,
              onTap: (index) => controller.changeTab(index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF1D3557),
              unselectedItemColor: Colors.grey[400],
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined, size: 28),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_rounded, size: 28),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.assignment_outlined, size: 28),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.assignment_rounded, size: 28),
                  ),
                  label: 'Complaint',
                ),
                // BottomNavigationBarItem(
                //   icon: Padding(
                //     padding: EdgeInsets.only(bottom: 4),
                //     child: Icon(Icons.analytics_outlined, size: 28),
                //   ),
                //   activeIcon: Padding(
                //     padding: EdgeInsets.only(bottom: 4),
                //     child: Icon(Icons.analytics_rounded, size: 28),
                //   ),
                //   label: 'Reports',
                // ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
