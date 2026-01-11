import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/providers/studentProfileProvider.dart';
import 'package:hsh_app/modules/student/features/home/home_components.dart';
import 'package:hsh_app/modules/student/features/attendance/attendance_screen.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_screen.dart';
import 'package:hsh_app/modules/student/features/payment/payment_screen.dart';
import 'package:hsh_app/modules/student/features/chat/chat_screen.dart';
import 'package:hsh_app/modules/student/features/notes/notes_screen.dart';
import 'package:hsh_app/modules/student/features/services/all_services_screen.dart';

import '../../../../providers/bottom_nav_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(studentProfileProvider);
    final padding = ResponsiveUtil.responsivePadding(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light grey background
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.apartment, color: Colors.blue),
            ),
            const SizedBox(width: 12),
            const Text(
              AppText.hostelHub,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: padding),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_none, color: Colors.black),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            HomeHeader(
              userName: profile.name.split(' ').first, // First name only
              roomNumber: profile.room,
              imagePath: profile.imagePath,
            ),
            SizedBox(height: vertical * 2),

            // Quick Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  AppText.quickActions,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllServicesScreen()),
                    );
                  },
                  child: const Text(
                    AppText.viewAll,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(
                    width: 110, // Fixed width for scrollable items
                    child: QuickActionCard(
                      icon: Icons.person_outline,
                      title: AppText.attendance,
                      subtitle: AppText.viewStatus,
                      iconColor: Colors.blue,
                      iconBgColor: Colors.blue.withOpacity(0.1),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const AttendanceScreen(),
                        //   ),
                        // );

                        ref.read(bottomNavIndexProvider.notifier).state = 2;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.payments_outlined,
                      title: 'Fees',
                      subtitle: AppText.payDue,
                      iconColor: Colors.green,
                      iconBgColor: Colors.green.withOpacity(0.1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.warning_amber_rounded,
                      title: AppText.complaint,
                      subtitle: AppText.raiseTicket,
                      iconColor: Colors.orange,
                      iconBgColor: Colors.orange.withOpacity(0.1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ComplaintScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.chat_bubble_outline,
                      title: AppText.chat,
                      subtitle: AppText.checkMessages,
                      iconColor: Colors.purple,
                      iconBgColor: Colors.purple.withOpacity(0.1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 110,
                    child: QuickActionCard(
                      icon: Icons.note_alt_outlined,
                      title: AppText.notes,
                      subtitle: AppText.keepNotes,
                      iconColor: Colors.teal,
                      iconBgColor: Colors.teal.withOpacity(0.1),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotesScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: vertical * 2),

            // Recent Activity
            const Text(
              AppText.recentActivity,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            // Mock Activity List
            const ActivityTile(
              icon: Icons.check_circle,
              iconColor: Colors.green,
              iconBgColor: Color(0xFFE8F5E9),
              title: AppText.feePaidSuccess,
              subtitle: 'June 12, 2024 • ${AppText.feeAmount}',
            ),
            const ActivityTile(
              icon: Icons.info_outline,
              iconColor: Colors.blue,
              iconBgColor: Color(0xFFE3F2FD),
              title: AppText.laundryReady,
              subtitle: 'June 11, 2024 • ${AppText.laundryLoad}',
            ),
          ],
        ),
      ),
    );
  }
}
