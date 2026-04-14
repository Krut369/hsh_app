import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_status_chip.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui hide AppColors;

class ComplaintDetailsSheet extends StatelessWidget {
  final Complaint complaint;
  final ScrollController scrollController;

  const ComplaintDetailsSheet({
    super.key,
    required this.complaint,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBF3F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        ComplaintUtils.getComplaintTypeIcon(
                            complaint.complaintType),
                        color: AppColors.headerBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ui.ModernText(
                            complaint.complaintType,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.headerBlue,
                          ),
                          ui.ModernText(
                            'Ticket ID: #${complaint.id}',
                            fontSize: 13,
                            color: Colors.grey[500]!,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildDetailRow(
                    "Status", ComplaintStatusChip(status: complaint.status)),
                const SizedBox(height: 16),
                _buildDetailRow(
                  "Date",
                  ui.ModernText(
                    DateFormat('MMM dd, yyyy • hh:mm a')
                        .format(complaint.dateTime),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headerBlue,
                  ),
                ),
                const SizedBox(height: 40),
                const ui.ModernText(
                  'Reported Issues',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                ),
                const SizedBox(height: 20),
                ...complaint.issues.entries.map((entry) {
                  final issueData = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFEBF3F5), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              ComplaintUtils.getSubComplaintIcon(
                                  complaint.complaintType, entry.key),
                              size: 18,
                              color: AppColors.headerBlue,
                            ),
                            const SizedBox(width: 10),
                            ui.ModernText(
                              entry.key,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.headerBlue,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ui.ModernText(
                          issueData.description,
                          fontSize: 14,
                          color: AppColors.headerBlue.withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                        if (issueData.imagePath != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(issueData.imagePath!),
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                height: 120,
                                width: double.infinity,
                                color: Colors.grey[200],
                                alignment: Alignment.center,
                                child: const Icon(Icons.broken_image,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, Widget value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ui.ModernText(label, fontSize: 14, color: Colors.grey[600]!),
        value,
      ],
    );
  }
}
