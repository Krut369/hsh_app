import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'complaint_detail_view_screen.dart';

class ComplaintAdminScreen extends GetView<ComplainController> {
  const ComplaintAdminScreen({super.key});

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
      default:
        return Icons.build;
    }
  }

  void _showStatusUpdateDialog(BuildContext context, Complaint complaint) {
    ComplaintStatus selectedStatus = complaint.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Status: ${complaint.complaintType}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...ComplaintStatus.values.map((status) {
              return RadioListTile<ComplaintStatus>(
                title: Text(status.label),
                value: status,
                groupValue: selectedStatus,
                onChanged: (value) {
                  if (value != null) {
                    Get.back(); // Close dialog
                    controller.updateStatus(complaint.id, value);
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Management',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.complaints.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredComplaints = controller.filteredComplaints;

        if (filteredComplaints.isEmpty) {
          return const Center(child: Text("No complaints matching filters"));
        }

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
          itemCount: filteredComplaints.length,
          itemBuilder: (context, index) {
            final complaint = filteredComplaints[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                onTap: () => Get.to(
                    () => ComplaintDetailViewScreen(complaint: complaint)),
                leading: Icon(_getComplaintTypeIcon(complaint.complaintType),
                    color: scheme.primary),
                title: Text(complaint.complaintType,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                    'Status: ${complaint.status.label}\n${DateFormat('MMM dd, yyyy').format(complaint.dateTime)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_note, color: Colors.blue),
                  onPressed: () => _showStatusUpdateDialog(context, complaint),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All Statuses'),
              onTap: () {
                controller.setFilter(null);
                Get.back();
              },
            ),
            ...ComplaintStatus.values.map((status) {
              return ListTile(
                title: Text(status.label),
                onTap: () {
                  controller.setFilter(status);
                  Get.back();
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
