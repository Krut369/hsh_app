import 'package:flutter/material.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';

class ComplaintStatusChip extends StatelessWidget {
  final ComplaintStatus status;

  const ComplaintStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = ComplaintUtils.getStatusColor(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            ComplaintUtils.getStatusIcon(status),
            color: color,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
