import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/complaint_model.dart';
import '../../../../providers/complaint_provider.dart';
import '../../../../widgets/custom_button.dart';

class ComplaintDetailViewScreen extends ConsumerStatefulWidget {
  final Complaint complaint;

  const ComplaintDetailViewScreen({
    super.key,
    required this.complaint,
  });

  @override
  ConsumerState<ComplaintDetailViewScreen> createState() =>
      _ComplaintDetailViewScreenState();
}

class _ComplaintDetailViewScreenState
    extends ConsumerState<ComplaintDetailViewScreen> {
  ComplaintStatus? selectedStatus;
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint.status;
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Color _getStatusColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return Colors.orange;
      case ComplaintStatus.pending:
        return const Color(0xFFFFA726);
      case ComplaintStatus.awaitingFeedback:
        return Colors.blue;
      case ComplaintStatus.resolved:
        return Colors.green;
    }
  }

  String _getStatusLabel(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return 'IN PROGRESS';
      case ComplaintStatus.pending:
        return 'PENDING';
      case ComplaintStatus.awaitingFeedback:
        return 'AWAITING FEEDBACK';
      case ComplaintStatus.resolved:
        return 'RESOLVED';
    }
  }

  void _updateComplaintStatus() {
    if (selectedStatus == null) return;

    final complaints = ref.read(complaintsProvider);
    final updatedComplaints = complaints.map((c) {
      if (c.id == widget.complaint.id) {
        return Complaint(
          id: c.id,
          dateTime: c.dateTime,
          complaintType: c.complaintType,
          issues: c.issues,
          status: selectedStatus!,
        );
      }
      return c;
    }).toList();

    ref.read(complaintsProvider.notifier).state = updatedComplaints;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Complaint status updated to ${selectedStatus!.label}'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  Widget _buildCodeStyleDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.complaint.issues.entries
            .map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                          text: '> ${entry.key}: ',
                          style: const TextStyle(
                            color: Color(0xFF4EC9B0),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: entry.value.description,
                          style: const TextStyle(
                            color: Color(0xFFCE9178),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(widget.complaint.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Complaint Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Section
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Alex Johnson',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'ID: #STU-${widget.complaint.id}',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.complaint.complaintType,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Complaint Description Section
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Complaint Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getStatusLabel(widget.complaint.status),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Image or Code-like display box
                  (widget.complaint.issues.isNotEmpty && widget.complaint.issues.entries.first.value.imagePath != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(widget.complaint.issues.entries.first.value.imagePath!),
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback to code-style display if image fails to load
                              return _buildCodeStyleDisplay();
                            },
                          ),
                        )
                      : _buildCodeStyleDisplay(),
                  const SizedBox(height: 20),
                  // Issue Title
                  Text(
                    widget.complaint.issues.isNotEmpty ? widget.complaint.issues.entries.first.key : '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Issue Description
                  Text(
                    widget.complaint.issues.isNotEmpty ? widget.complaint.issues.entries.first.value.description : '',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Submitted Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Submitted: ${DateFormat('MMM dd, yyyy • hh:mm a').format(widget.complaint.dateTime)}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Update Progress Section
            Container(
              width: double.infinity,
              color: AppColors.background,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Change Status Label
                  Text(
                    'Change Status',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Status Dropdown
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonFormField<ComplaintStatus>(
                      value: selectedStatus,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: ComplaintStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusLabel(status)),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Admin Remarks Label
                  Text(
                    'Admin Remarks',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Remarks TextField
                  TextField(
                    controller: remarksController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Provide details about the resolution or next steps...',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Update Status Button
                  CustomButton(
                    text: 'Update Status',
                    onPressed: _updateComplaintStatus,
                    backgroundColor: AppColors.primary,
                    borderRadius: 8,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
