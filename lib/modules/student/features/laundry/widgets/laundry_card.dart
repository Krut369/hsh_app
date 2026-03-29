import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_utils.dart';
import 'package:hsh_app/modules/student/features/laundry/widgets/laundry_status_chip.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:uitoolkit/uitoolkit.dart' as ui;

class LaundryCard extends StatelessWidget {
  final LaundryOrderEntity order;
  final VoidCallback onTap;

  const LaundryCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = LaundryUtils.getStatusColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withValues(alpha: 0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBF3F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LaundryUtils.getServiceIcon(order.serviceType),
                        color: AppColors.headerBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Service and Date Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ui.ModernText(
                            order.serviceType,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headerBlue,
                          ),
                          const SizedBox(height: 4),
                          ui.ModernText(
                            DateFormat('dd MMM yyyy').format(order.date),
                            fontSize: 12,
                            color: Colors.grey[500]!,
                          ),
                        ],
                      ),
                    ),
                    
                    // Status Badge
                    LaundryStatusChip(status: order.status),
                  ],
                ),
                
                if (order.items.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEBF3F5)),
                  const SizedBox(height: 16),
                  
                  // Details Section (Primary Item)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.local_laundry_service_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ui.ModernText(
                          "${order.items.first.name} (${order.items.first.quantity} units)",
                          fontSize: 14,
                          color: AppColors.headerBlue.withValues(alpha: 0.8),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                  
                  // More items counter
                  if (order.items.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 30),
                      child: ui.ModernText(
                        "+ ${order.items.length - 1} more items",
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.headerBlue,
                      ),
                    ),
                ] else ...[
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: Color(0xFFEBF3F5)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 18, color: Colors.grey),
                      const SizedBox(width: 12),
                      ui.ModernText(
                        "No items in this order",
                        fontSize: 14,
                        color: Colors.grey[500]!,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
