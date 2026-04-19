import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_utils.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        // ClipRRect so the left strip respects rounded corners
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Left status-coloured accent strip ───────────────────
                Container(width: 5, color: statusColor),

                // ── Card content ────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: icon + service/date + status chip
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Service icon circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBF3F5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                LaundryUtils.getServiceIcon(order.serviceType),
                                color: AppColors.headerBlue,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Service type + date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ModernText(
                                    order.serviceType,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.headerBlue,
                                  ),
                                  const SizedBox(height: 3),
                                  ModernText(
                                    DateFormat('d MMM yyyy').format(order.date),
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Status chip
                            _LaundryStatusChip(
                              status: order.status,
                              color: statusColor,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 12),

                        // Items section
                        if (order.items.isNotEmpty) ...[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.menu,
                                  size: 18, color: Colors.grey.shade400),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ModernText(
                                  order.items
                                      .map((e) => '${e.name} (${e.quantity} units)')
                                      .join(', '),
                                  fontSize: 13,
                                  color: AppColors.headerBlue
                                      .withValues(alpha: 0.8),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ] else
                          Row(
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  size: 18, color: Colors.grey.shade400),
                              const SizedBox(width: 10),
                              ModernText(
                                'No items in this order',
                                fontSize: 13,
                                color: Colors.grey.shade500,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Laundry Status Chip ────────────────────────────────────────────────────────

class _LaundryStatusChip extends StatelessWidget {
  final OrderStatus status;
  final Color color;

  const _LaundryStatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LaundryUtils.getStatusIcon(status), color: color, size: 12),
          const SizedBox(width: 4),
          ModernText(
            status.label,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
