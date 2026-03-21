import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/widgets/custom_button.dart';

class ComplaintDetailViewScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailViewScreen({
    super.key,
    required this.complaint,
  });

  @override
  State<ComplaintDetailViewScreen> createState() =>
      _ComplaintDetailViewScreenState();
}

class _ComplaintDetailViewScreenState extends State<ComplaintDetailViewScreen> {
  final ComplainController controller = Get.find<ComplainController>();
  late ComplaintStatus? selectedStatus;
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

  void _updateComplaintStatus() async {
    if (selectedStatus == null) return;

    await controller.updateStatus(widget.complaint.id, selectedStatus!);
    Get.back(); // Go back after update
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
                          style: const TextStyle(color: Color(0xFF4EC9B0)),
                        ),
                        TextSpan(
                          text: entry.value.description,
                          style: const TextStyle(color: Color(0xFFCE9178)),
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
        title: const Text('Complaint Details',
            style: TextStyle(color: Colors.white, fontSize: 18)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            Row(
              children: [
                const CircleAvatar(
                    radius: 30, child: Icon(Icons.person, size: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Alex Johnson',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('ID: #STU-${widget.complaint.id}',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                      Text(widget.complaint.complaintType,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.primary)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(widget.complaint.status.label,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor)),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Issues Section
            const Text('Complaint Description',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCodeStyleDisplay(),
            const SizedBox(height: 16),
            Text(
                'Submitted: ${DateFormat('MMM dd, yyyy • hh:mm a').format(widget.complaint.dateTime)}',
                style: const TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 32),

            // Management Section
            const Text('Update Progress',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<ComplaintStatus>(
              value: selectedStatus,
              decoration: const InputDecoration(
                  labelText: 'Status', border: OutlineInputBorder()),
              items: ComplaintStatus.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (v) => setState(() => selectedStatus = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: remarksController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Admin Remarks',
                  border: OutlineInputBorder(),
                  hintText: 'Next steps...'),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Update Status',
              onPressed: _updateComplaintStatus,
              backgroundColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
