import 'package:flutter/material.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_utils.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;

/// Reusable laundry status chip using uitoolkit [ModernText].
class LaundryStatusChip extends StatelessWidget {
  final OrderStatus status;

  const LaundryStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = LaundryUtils.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 115),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LaundryUtils.getStatusIcon(status), color: color, size: 13),
          const SizedBox(width: 5),
          Flexible(
            child: ModernText(
              status.label,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
