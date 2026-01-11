import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/modules/student/features/complaint/add_complaint_screen.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/providers/complaint_provider.dart';

class ComplaintScreen extends ConsumerWidget {
  const ComplaintScreen({super.key});

  Color _getStatusColor(BuildContext context, ComplaintStatus status) {
    final scheme = Theme.of(context).colorScheme;
    switch (status) {
      case ComplaintStatus.underReview:
        return Colors.orange;
      case ComplaintStatus.pending:
        return scheme.secondary;
      case ComplaintStatus.awaitingFeedback:
        return Colors.blue;
      case ComplaintStatus.resolved:
        return Colors.green;
    }
  }

  IconData _getComplaintTypeIcon(String typeName) {
    switch (typeName) {
      case 'Electrical':
        return Icons.electrical_services;
      case 'Plumbing':
        return Icons.water_damage;
      case 'Carpentry':
        return Icons.handyman;
      case 'Housekeeping':
        return Icons.cleaning_services;
      case 'Internet':
        return Icons.wifi;
      case 'Others':
        return Icons.miscellaneous_services;
      default:
        return Icons.build;
    }
  }

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.read(complaintFilterProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.filterComplaints, style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ComplaintStatus?>(
              title: const Text('All'),
              value: null,
              groupValue: currentFilter,
              onChanged: (value) {
                ref.read(complaintFilterProvider.notifier).state = value;
                Navigator.pop(context);
              },
            ),
            ...ComplaintStatus.values.map((status) {
              return RadioListTile<ComplaintStatus?>(
                title: Text(status.label),
                value: status,
                groupValue: currentFilter,
                onChanged: (value) {
                  ref.read(complaintFilterProvider.notifier).state = value;
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppText.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaints = ref.watch(filteredComplaintsProvider);
    final filter = ref.watch(complaintFilterProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtil.responsivePadding(context),
              vertical: ResponsiveUtil.verticalSpacing(context),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Filter controls
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(
                        label: Text(
                          filter?.label ?? 'All',
                          style: textTheme.labelLarge?.copyWith(color: scheme.primary),
                        ),
                        backgroundColor: scheme.primary.withOpacity(0.1),
                      ),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.filter_list),
                        label: Text(AppText.filter),
                        onPressed: () => _showFilterDialog(context, ref),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.primary,
                          side: BorderSide(color: scheme.primary),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right: Add Complaint button
                SizedBox(
                  width: ResponsiveUtil.isMobile(context)
                      ? MediaQuery.of(context).size.width * 0.43
                      : MediaQuery.of(context).size.width * 0.25,
                  height: 50,
                  child: CustomButton(
                    text: AppText.addComplaint,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AddComplaintScreen()),
                      );
                    },
                    borderRadius: 30,
                  ),
                ),
              ],
            ),
          ),
          // Complaint List
          Expanded(
            child: complaints.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 64, color: scheme.onSurface.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'No ${filter?.label.toLowerCase() ?? 'complaints'} found',
                    style: textTheme.titleMedium?.copyWith(color: scheme.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
              itemCount: complaints.length,
              itemBuilder: (context, index) {
                final complaint = complaints[index];
                final statusColor = _getStatusColor(context, complaint.status);

                return Card(
                  margin: EdgeInsets.only(bottom: ResponsiveUtil.verticalSpacing(context)),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.7,
                          minChildSize: 0.5,
                          maxChildSize: 0.95,
                          expand: false,
                          builder: (context, scrollController) => SingleChildScrollView(
                            controller: scrollController,
                            padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 40,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 20),
                                    decoration: BoxDecoration(
                                      color: scheme.onSurface.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(_getComplaintTypeIcon(complaint.complaintType), color: scheme.primary),
                                    const SizedBox(width: 12),
                                    Text(
                                      complaint.complaintType,
                                      style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                _buildStatusChip(statusColor, complaint.status),
                                const SizedBox(height: 16),
                                Text(
                                  'Submitted on ${DateFormat('MMM dd, yyyy hh:mm a').format(complaint.dateTime)}',
                                  style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.6)),
                                ),
                                const SizedBox(height: 24),
                                Text('Issues Reported:', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 12),
                                ...complaint.descriptions.entries.map((entry) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(entry.key, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(entry.value, style: textTheme.bodyLarge),
                                    ],
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(_getComplaintTypeIcon(complaint.complaintType), color: scheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  complaint.complaintType,
                                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              _buildStatusChip(statusColor, complaint.status),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat('MMM dd, yyyy hh:mm a').format(complaint.dateTime),
                            style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.6)),
                          ),
                          if (complaint.descriptions.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              complaint.descriptions.entries.first.value,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.7)),
                            ),
                            if (complaint.descriptions.length > 1)
                              Text(
                                '+${complaint.descriptions.length - 1} more issues',
                                style: textTheme.bodySmall?.copyWith(color: scheme.onSurface.withOpacity(0.5)),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatusChip(Color color, ComplaintStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(status),
            color: color,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

}

IconData _getStatusIcon(ComplaintStatus status) {
  switch (status) {
    case ComplaintStatus.underReview:
      return Icons.visibility;
    case ComplaintStatus.pending:
      return Icons.pending_actions;
    case ComplaintStatus.awaitingFeedback:
      return Icons.feedback;
    case ComplaintStatus.resolved:
      return Icons.check_circle;
  }
}


