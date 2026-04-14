import 'package:flutter/material.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

/// Reusable status chip using uitoolkit [ModernText].
/// Uses a colored pill with icon + label matching the complaint status.
class ComplaintStatusChip extends StatelessWidget {
  final ComplaintStatus status;

  const ComplaintStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = ComplaintUtils.getStatusColor(context, status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 115),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            ComplaintUtils.getStatusIcon(status),
            color: color,
            size: 13,
          ),
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
