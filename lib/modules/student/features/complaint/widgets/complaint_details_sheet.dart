import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_status_chip.dart';

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
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
                      decoration: BoxDecoration(
                        color: scheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                          ComplaintUtils.getComplaintTypeIcon(
                              complaint.complaintType),
                          color: scheme.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(complaint.complaintType,
                            style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        Text(
                          'Ticket ID: #${complaint.id}',
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 13),
                        )
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status', style: TextStyle(color: Colors.grey)),
                    ComplaintStatusChip(status: complaint.status)
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Date', style: TextStyle(color: Colors.grey)),
                    Text(
                      DateFormat('MMM dd, yyyy • hh:mm a')
                          .format(complaint.dateTime),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(height: 32),
                Text('Reported Issues',
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...complaint.issues.entries.map((entry) {
                  final issueData = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (complaint.complaintType == 'Electrical' ||
                                complaint.complaintType == 'Plumbing' ||
                                complaint.complaintType == 'Carpentry') ...[
                              Icon(
                                  ComplaintUtils.getSubComplaintIcon(
                                      complaint.complaintType, entry.key),
                                  size: 18,
                                  color: Colors.grey[700]),
                              const SizedBox(width: 8),
                            ],
                            Text(entry.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(issueData.description,
                            style: TextStyle(
                                color: Colors.grey[800], height: 1.5)),
                        if (issueData.imagePath != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(issueData.imagePath!),
                              height: 120,
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
}
