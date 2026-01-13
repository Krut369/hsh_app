import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../laundry/controllers/laundry_filter_provider.dart';
import '../../../../providers/bottom_nav_provider.dart';

class LaundryHomeScreen extends ConsumerWidget {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = ResponsiveUtil.responsivePadding(context);

    // Using specific colors from the design description/inference
    const successGreen = Color(0xFF10B981);
    const warningOrange = Color(0xFFF59E0B);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
              'Laundry',
              style: AppFonts.heading2(context).copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right:12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle
              ),
                padding: EdgeInsets.all(6),
                child: Badge(
                    child: Icon(Icons.notifications_none,color: Colors.white,size: 24,))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom AppBar / Header
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const CircleAvatar(
            //       backgroundImage: NetworkImage(
            //           'https://i.pravatar.cc/150?img=11'), // Placeholder
            //       radius: 20,
            //     ),
            //     Text(
            //       'Laundry',
            //       style: AppFonts.heading2(context).copyWith(
            //         color: AppColors.textPrimary,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //     Stack(
            //       children: [
            //         const Icon(Icons.notifications,
            //             size: 28, color: AppColors.textPrimary),
            //         Positioned(
            //           right: 0,
            //           top: 0,
            //           child: Container(
            //             width: 10,
            //             height: 10,
            //             decoration: BoxDecoration(
            //               color: Colors.red,
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                   color: AppColors.background, width: 2),
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 24),

            // Overview Section
            Text(
              'OVERVIEW',
              style: AppFonts.heading3(context).copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textPrimary,letterSpacing: 1.5),
            ),
            const SizedBox(height: 16),

            // Total Requests Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Requests',
                          style: AppFonts.bodyRegular(context)
                              .copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Text('124',
                          style: AppFonts.heading1(context).copyWith(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary)),

                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.assignment,
                        color: AppColors.primary, size: 28),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Row of Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Pending Pickups',
                    value: '18',
                    trendColor: warningOrange,
                    icon: Icons.pending_actions,
                    iconColor: warningOrange,
                    iconBg: const Color(0xFFFFF3E0),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    context,
                    title: 'Delivered Today',
                    value: '86',
                    trendColor: successGreen,
                    icon: Icons.local_shipping,
                    iconColor: successGreen,
                    iconBg: const Color(0xFFE8F5E9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Quick Actions Section
            Text(
              'Quick Actions',
              style: AppFonts.heading3(context).copyWith(
                  fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 16),

            // View All Requests Button
            ElevatedButton(
              onPressed: () {
                 ref.read(laundryFilterProvider.notifier).state = 'All';
                 ref.read(bottomNavIndexProvider.notifier).state = 1; // Switch to Detail Tab (Requests)
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
              child: Row(
                children: [
                  const Icon(Icons.list),
                  const SizedBox(width: 12),
                  Text('View All Requests',
                      style: AppFonts.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  const Spacer(),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Pending Pickups Button
            OutlinedButton(
              onPressed: () {
                 ref.read(laundryFilterProvider.notifier).state = 'Ready for Pickup';
                 ref.read(bottomNavIndexProvider.notifier).state = 1; // Switch to Detail Tab (Requests)
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.surface,
                side: const BorderSide(color: AppColors.primary, width: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                foregroundColor: AppColors.primary,
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 12),
                  Text('Pending Pickups',
                      style: AppFonts.bodyMedium(context).copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '18',
                      style: AppFonts.smallText(context).copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height:
                    32), // Added extra spacing since the map was removed but we want bottom padding
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,

    required Color trendColor,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 16),
          Text(title,
              style: AppFonts.smallText(context)
                  .copyWith(color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text(value,
              style: AppFonts.heading3(context)
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 24)),
          // const SizedBox(height: 8),
          // Text(
          //   trendText,
          //   style: AppFonts.smallText(context)
          //       .copyWith(color: trendColor, fontWeight: FontWeight.bold),
          // ),
        ],
      ),
    );
  }
}
