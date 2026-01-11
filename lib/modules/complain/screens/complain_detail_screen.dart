import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/responsive_util.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';
import 'complaint_detail_view_screen.dart';

class ComplaintAdminScreen extends ConsumerStatefulWidget {
  const ComplaintAdminScreen({super.key});

  @override
  ConsumerState<ComplaintAdminScreen> createState() =>
      _ComplaintAdminScreenState();
}

class _ComplaintAdminScreenState extends ConsumerState<ComplaintAdminScreen> {
  ComplaintStatus? selectedStatusFilter;
  String? selectedTypeFilter;
  bool isGridView = false;

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

  void _showStatusUpdateDialog(BuildContext context, Complaint complaint) {
    ComplaintStatus selectedStatus = complaint.status;
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Update Status: ${complaint.complaintType}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Current Status: ${complaint.status.label}'),
                SizedBox(height: ResponsiveUtil.verticalSpacing(context)),
                Text('New Status:',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
                ...ComplaintStatus.values.map((status) {
                  return RadioListTile<ComplaintStatus>(
                    title: Text(status.label),
                    value: status,
                    groupValue: selectedStatus,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedStatus = value!;
                      });
                    },
                  );
                }),
                SizedBox(height: ResponsiveUtil.verticalSpacing(context)),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Notes (Optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateComplaintStatus(
                    complaint, selectedStatus, notesController.text);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateComplaintStatus(
      Complaint complaint, ComplaintStatus newStatus, String notes) {
    final complaints = ref.read(complaintsProvider);
    final updatedComplaints = complaints.map((c) {
      if (c.id == complaint.id) {
        return Complaint(
          id: c.id,
          dateTime: c.dateTime,
          complaintType: c.complaintType,
          descriptions: c.descriptions,
          imagePath: c.imagePath,
          status: newStatus,
        );
      }
      return c;
    }).toList();

    ref.read(complaintsProvider.notifier).state = updatedComplaints;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complaint status updated to ${newStatus.label}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final complaints = ref.read(complaintsProvider);
    final uniqueTypes = complaints.map((c) => c.complaintType).toSet().toList();

    // Create local variables to track dialog state
    ComplaintStatus? tempStatusFilter = selectedStatusFilter;
    String? tempTypeFilter = selectedTypeFilter;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Filter Complaints'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Status Filter
                Text('Filter by Status:',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
                DropdownButton<ComplaintStatus?>(
                  value: tempStatusFilter,
                  hint: const Text('All Statuses'),
                  isExpanded: true,
                  onChanged: (value) {
                    setDialogState(() {
                      tempStatusFilter = value;
                    });
                  },
                  items: [
                    const DropdownMenuItem<ComplaintStatus?>(
                      value: null,
                      child: Text('All Statuses'),
                    ),
                    ...ComplaintStatus.values.map((status) {
                      return DropdownMenuItem<ComplaintStatus?>(
                        value: status,
                        child: Text(status.label),
                      );
                    }),
                  ],
                ),
                SizedBox(height: ResponsiveUtil.verticalSpacing(context)),
                // Type Filter
                Text('Filter by Type:',
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
                DropdownButton<String?>(
                  value: tempTypeFilter,
                  hint: const Text('All Types'),
                  isExpanded: true,
                  onChanged: (value) {
                    setDialogState(() {
                      tempTypeFilter = value;
                    });
                  },
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All Types'),
                    ),
                    ...uniqueTypes.map((type) {
                      return DropdownMenuItem<String?>(
                        value: type,
                        child: Text(type),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setDialogState(() {
                  tempStatusFilter = null;
                  tempTypeFilter = null;
                });
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedStatusFilter = tempStatusFilter;
                  selectedTypeFilter = tempTypeFilter;
                });
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }

  List<Complaint> _getFilteredComplaints() {
    final complaints = ref.watch(complaintsProvider);

    return complaints.where((complaint) {
      final statusMatch = selectedStatusFilter == null ||
          complaint.status == selectedStatusFilter;
      final typeMatch = selectedTypeFilter == null ||
          complaint.complaintType == selectedTypeFilter;
      return statusMatch && typeMatch;
    }).toList();
  }

  Widget _buildComplaintCard(Complaint complaint) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getStatusColor(context, complaint.status);

    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveUtil.verticalSpacing(context)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showComplaintDetails(complaint),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getComplaintTypeIcon(complaint.complaintType),
                    color: scheme.primary,
                    size: ResponsiveUtil.responsiveIconSize(context, 24),
                  ),
                  SizedBox(width: ResponsiveUtil.horizontalSpacing(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          complaint.complaintType,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize:
                                ResponsiveUtil.responsiveFontSize(context, 16),
                          ),
                        ),
                        Text(
                          'ID: ${complaint.id}',
                          style: textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                            fontSize:
                                ResponsiveUtil.responsiveFontSize(context, 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(statusColor, complaint.status),
                ],
              ),
              SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
              Text(
                DateFormat('MMM dd, yyyy hh:mm a').format(complaint.dateTime),
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.6),
                  fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                ),
              ),
              if (complaint.descriptions.isNotEmpty) ...[
                SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
                Text(
                  complaint.descriptions.entries.first.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.7),
                    fontSize: ResponsiveUtil.responsiveFontSize(context, 14),
                  ),
                ),
                if (complaint.descriptions.length > 1)
                  Text(
                    '+${complaint.descriptions.length - 1} more issues',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.5),
                      fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                    ),
                  ),
              ],
              SizedBox(height: ResponsiveUtil.verticalSpacing(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      Icons.edit,
                      size: ResponsiveUtil.responsiveIconSize(context, 16),
                    ),
                    label: Text(
                      'Update Status',
                      style: TextStyle(
                        fontSize:
                            ResponsiveUtil.responsiveFontSize(context, 14),
                      ),
                    ),
                    onPressed: () =>
                        _showStatusUpdateDialog(context, complaint),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      side: BorderSide(color: scheme.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComplaintGridTile(Complaint complaint) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final statusColor = _getStatusColor(context, complaint.status);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showComplaintDetails(complaint),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getComplaintTypeIcon(complaint.complaintType),
                    color: scheme.primary,
                    size: ResponsiveUtil.responsiveIconSize(context, 20),
                  ),
                  SizedBox(width: ResponsiveUtil.horizontalSpacing(context)),
                  Expanded(
                    child: Text(
                      complaint.complaintType,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            ResponsiveUtil.responsiveFontSize(context, 14),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
              _buildStatusChip(statusColor, complaint.status),
              SizedBox(height: ResponsiveUtil.horizontalSpacing(context)),
              Text(
                'ID: ${complaint.id}',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.6),
                  fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy').format(complaint.dateTime),
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.6),
                  fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => _showStatusUpdateDialog(context, complaint),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.primary,
                    side: BorderSide(color: scheme.primary),
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveUtil.horizontalSpacing(context),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showComplaintDetails(Complaint complaint) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ComplaintDetailViewScreen(complaint: complaint),
      ),
    );
  }

  Widget _buildStatusChip(Color color, ComplaintStatus status) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtil.horizontalSpacing(context),
        vertical: 6,
      ),
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
            size: ResponsiveUtil.responsiveIconSize(context, 16),
          ),
          SizedBox(width: ResponsiveUtil.horizontalSpacing(context) - 2),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final filteredComplaints = _getFilteredComplaints();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaint Management',
          style: TextStyle(
            fontSize: ResponsiveUtil.responsiveFontSize(context, 20),
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(
              isGridView ? Icons.view_list : Icons.grid_view,
              size: ResponsiveUtil.responsiveIconSize(context, 24),
            ),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              size: ResponsiveUtil.responsiveIconSize(context, 24),
            ),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Info
          if (selectedStatusFilter != null || selectedTypeFilter != null)
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveUtil.responsivePadding(context)),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    size: ResponsiveUtil.responsiveIconSize(context, 16),
                  ),
                  SizedBox(width: ResponsiveUtil.horizontalSpacing(context)),
                  Text(
                    'Filtered: ${selectedStatusFilter?.label ?? 'All Statuses'}${selectedTypeFilter != null ? ' • $selectedTypeFilter' : ''}',
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurface.withOpacity(0.6),
                      fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedStatusFilter = null;
                        selectedTypeFilter = null;
                      });
                    },
                    child: Text(
                      'Clear',
                      style: TextStyle(
                        fontSize:
                            ResponsiveUtil.responsiveFontSize(context, 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          // Complaint List/Grid
          Expanded(
            child: filteredComplaints.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_rounded,
                          size: ResponsiveUtil.responsiveIconSize(context, 64),
                          color: scheme.onSurface.withOpacity(0.2),
                        ),
                        SizedBox(
                            height: ResponsiveUtil.verticalSpacing(context)),
                        Text(
                          'No complaints found',
                          style: textTheme.titleMedium?.copyWith(
                            color: scheme.onSurface.withOpacity(0.6),
                            fontSize:
                                ResponsiveUtil.responsiveFontSize(context, 16),
                          ),
                        ),
                        SizedBox(
                            height: ResponsiveUtil.horizontalSpacing(context)),
                        Text(
                          'Try adjusting your filters',
                          style: textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurface.withOpacity(0.4),
                            fontSize:
                                ResponsiveUtil.responsiveFontSize(context, 14),
                          ),
                        ),
                      ],
                    ),
                  )
                : isGridView
                    ? GridView.builder(
                        padding: EdgeInsets.all(
                            ResponsiveUtil.responsivePadding(context)),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              ResponsiveUtil.responsiveGridCount(context),
                          crossAxisSpacing:
                              ResponsiveUtil.horizontalSpacing(context),
                          mainAxisSpacing:
                              ResponsiveUtil.verticalSpacing(context),
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {
                          final complaint = filteredComplaints[index];
                          return _buildComplaintGridTile(complaint);
                        },
                      )
                    : ListView.builder(
                        padding: EdgeInsets.all(
                            ResponsiveUtil.responsivePadding(context)),
                        itemCount: filteredComplaints.length,
                        itemBuilder: (context, index) {
                          final complaint = filteredComplaints[index];
                          return _buildComplaintCard(complaint);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
