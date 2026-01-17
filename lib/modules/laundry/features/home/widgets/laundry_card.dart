import 'package:flutter/material.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/constants/font.dart';
import '../../../../../../models/laundry_order_model.dart';
import 'package:intl/intl.dart';

class LaundryCard extends StatelessWidget {
  final LaundryOrder order;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const LaundryCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors and labels based on status
    final statusColor = order.status.backgroundColor;
    final statusTextColor = order.status.textColor;
    
    String actionLabel;
    Color actionColor;
    Color actionTextColor;
    bool isFinished = order.status == OrderStatus.completed || order.status == OrderStatus.cancelled;

    switch (order.status) {
      case OrderStatus.requested:
        actionLabel = 'Accept'; 
        actionColor = AppColors.primary;
        actionTextColor = Colors.white;
        break;
      case OrderStatus.inProgress:
        actionLabel = 'Update Status';
        actionColor = const Color(0xFFE3F2FD);
        actionTextColor = AppColors.primary;
        break;
      case OrderStatus.readyForPickup:
        actionLabel = 'Mark Delivered';
        actionColor = const Color(0xFFFFF3E0);
        actionTextColor = AppColors.warningOrange;
        break;
      case OrderStatus.completed:
        actionLabel = 'Finished';
        actionColor = const Color(0xFFE8F5E9);
        actionTextColor = AppColors.successGreen;
        break;
       case OrderStatus.cancelled:
        actionLabel = 'Cancelled';
        actionColor = const Color(0xFFFFEBEE);
        actionTextColor = Colors.red;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: Name and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Student Name', // Placeholder until User model integration
                        style: AppFonts.heading3(context).copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${order.orderId} • ${order.totalItems} Items',
                        style: AppFonts.bodyMedium(context).copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.label,
                    style: AppFonts.smallText(context).copyWith(
                      color: statusTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),

            // Footer: Time and Action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('MMM d, h:mm a').format(order.date),
                      style: AppFonts.smallText(context).copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Action Button Logic
                if (isFinished)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: actionColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Icon(Icons.check_circle,
                            size: 16, color: actionTextColor),
                        const SizedBox(width: 6),
                        Text(
                          actionLabel,
                          style: AppFonts.buttonText(context).copyWith(
                            color: actionTextColor,
                            fontSize: 13,
                          ),
                        )
                      ]))
                else
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onActionTap,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(actionLabel,
                                style: AppFonts.buttonText(context).copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                )),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded,
                                size: 16, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
