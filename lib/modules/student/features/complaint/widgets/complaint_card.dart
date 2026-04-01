import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;
  final VoidCallback onTap;

  const ComplaintCard({
    super.key,
    required this.complaint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = ComplaintUtils.getStatusColor(context, complaint.status);

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
                // ── Left coloured accent strip (status-based colour) ────
                Container(width: 5, color: statusColor),

                // ── Card content ────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top row: icon + title/date + status chip
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Category icon circle
                            Container(
                              width: 48,
                              height: 48,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEBF3F5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                ComplaintUtils.getComplaintTypeIcon(
                                    complaint.complaintType),
                                color: AppColors.headerBlue,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Title + date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ModernText(
                                    complaint.complaintType,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.headerBlue,
                                  ),
                                  const SizedBox(height: 3),
                                  ModernText(
                                    DateFormat('d MMM yyyy, h:mm a')
                                        .format(complaint.dateTime),
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Status pill chip
                            _StatusChip(
                              status: complaint.status,
                              color: statusColor,
                            ),
                          ],
                        ),

                        if (complaint.issues.isNotEmpty) ...[
                          const SizedBox(height: 14),
                          Divider(height: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 12),

                          // Description
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.menu,
                                  size: 18, color: Colors.grey.shade400),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ModernText(
                                  complaint.issues.entries.first.value
                                      .description,
                                  fontSize: 13,
                                  color: AppColors.headerBlue
                                      .withValues(alpha: 0.8),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          // Sub-issues counter
                          if (complaint.issues.length > 1)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, left: 28),
                              child: ModernText(
                                '+ ${complaint.issues.length - 1} more sub-issues',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.headerBlue,
                              ),
                            ),
                        ],
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

// ── Status Chip ────────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final ComplaintStatus status;
  final Color color;

  const _StatusChip({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
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
          Icon(ComplaintUtils.getStatusIcon(status), color: color, size: 13),
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
