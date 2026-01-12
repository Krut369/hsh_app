import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/complaint_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../providers/complaint_provider.dart';

import 'stat_card_widget.dart';

class ComplainHomeScreen extends ConsumerStatefulWidget {
  const ComplainHomeScreen({super.key});

  @override
  ConsumerState<ComplainHomeScreen> createState() => _ComplainHomeScreenState();
}

class _ComplainHomeScreenState extends ConsumerState<ComplainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final totalComplaints = ref.watch(totalComplaintCountProvider);
    final pendingCount =
        ref.watch(complaintCountByStatusProvider(ComplaintStatus.pending));
    final resolvedCount =
        ref.watch(complaintCountByStatusProvider(ComplaintStatus.resolved));
    final authNotifier = ref.read(authProvider.notifier);

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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white),
                onPressed: () {
                  // Handle notification tap
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  authNotifier.logout();
                },
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
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
            //const SizedBox(height: 10),
            // Stat Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  StatCardWidget(
                    title: 'TOTAL COMPLAINTS',
                    value: totalComplaints.toString(),
                    percentage: '+12%',
                    isPositive: true,
                    icon: Icons.bar_chart,
                    borderColor: const Color(0xFF2196F3),
                    iconColor: const Color(0xFF2196F3),
                  ),
                  StatCardWidget(
                    title: 'PENDING',
                    value: pendingCount.toString(),
                    percentage: '+5%',
                    isPositive: true,
                    icon: Icons.pending_actions,
                    borderColor: const Color(0xFFFF9800),
                    iconColor: const Color(0xFFFF9800),
                  ),
                  StatCardWidget(
                    title: 'RESOLVED',
                    value: resolvedCount.toString(),
                    percentage: '-2%',
                    isPositive: false,
                    icon: Icons.check_circle_outline,
                    borderColor: const Color(0xFF4CAF50),
                    iconColor: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Recent Activity Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Text(
            //         'Recent Activity',
            //         style: TextStyle(
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.black87,
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () {
            //           // Handle view all
            //         },
            //         child: const Text(
            //           'View All',
            //           style: TextStyle(
            //             fontSize: 14,
            //             fontWeight: FontWeight.w600,
            //             color: Color(0xFF2196F3),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 8),
            // // Activity Items
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Column(
            //     children: [
            //       ActivityItemWidget(
            //         icon: Icons.ac_unit,
            //         iconBackgroundColor: const Color(0xFFE3F2FD),
            //         iconColor: const Color(0xFF2196F3),
            //         title: 'AC Maintenance - Room...',
            //         description: 'New complaint filed by Faculty',
            //         timeAgo: '2M AGO',
            //         status: 'NEW',
            //         statusColor: const Color(0xFF2196F3),
            //         onTap: () {
            //           // Handle tap
            //         },
            //       ),
            //       ActivityItemWidget(
            //         icon: Icons.wifi,
            //         iconBackgroundColor: const Color(0xFFE8F5E9),
            //         iconColor: const Color(0xFF4CAF50),
            //         title: 'WiFi Connectivity - La...',
            //         description: 'Status updated to Resolved',
            //         timeAgo: '1H AGO',
            //         status: 'DONE',
            //         statusColor: const Color(0xFF4CAF50),
            //         onTap: () {
            //           // Handle tap
            //         },
            //       ),
            //       ActivityItemWidget(
            //         icon: Icons.flash_on,
            //         iconBackgroundColor: const Color(0xFFFFF3E0),
            //         iconColor: const Color(0xFFFF9800),
            //         title: 'Power Failure - Bloc...',
            //         description: 'Assigned to Maintenance...',
            //         timeAgo: '3H AGO',
            //         status: 'PENDING',
            //         statusColor: const Color(0xFFFF9800),
            //         onTap: () {
            //           // Handle tap
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
