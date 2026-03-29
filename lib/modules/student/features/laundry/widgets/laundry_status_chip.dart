import 'package:flutter/material.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_utils.dart';

class LaundryStatusChip extends StatelessWidget {
  final OrderStatus status;

  const LaundryStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = LaundryUtils.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            LaundryUtils.getStatusIcon(status),
            color: color,
            size: 14,
          ),
          const SizedBox(width: 8),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
