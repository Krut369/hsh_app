import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_card.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_details_sheet.dart';

class ComplaintScreen extends GetView<ComplainController> {
  const ComplaintScreen({super.key});

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.filterComplaints,
            style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => RadioListTile<ComplaintStatus?>(
                  title: const Text('All'),
                  value: null,
                  groupValue: controller.filter.value,
                  onChanged: (value) {
                    controller.setFilter(value);
                    Get.back();
                  },
                )),
            ...ComplaintStatus.values.map((status) {
              return Obx(() => RadioListTile<ComplaintStatus?>(
                    title: Text(status.label),
                    value: status,
                    groupValue: controller.filter.value,
                    onChanged: (value) {
                      controller.setFilter(value);
                      Get.back();
                    },
                  ));
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppText.cancel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: AppText.complaint,
        showNotificationIcon: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() => ActionChip(
                  avatar:
                      Icon(Icons.filter_list, size: 16, color: scheme.primary),
                  label: Text(
                    controller.filter.value?.label ?? 'All',
                    style: TextStyle(
                        color: scheme.primary, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  onPressed: () => _showFilterDialog(context),
                )),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/student/complaint/add'),
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.complaints.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final complaintsList = controller.filteredComplaints;

        if (complaintsList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ]),
                  child: Icon(Icons.history_edu,
                      size: 48, color: Colors.grey[400]),
                ),
                const SizedBox(height: 16),
                Text(
                  'No ${controller.filter.value?.label.toLowerCase() ?? ''} complaints found',
                  style:
                      textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Have an issue? Raise a ticket now.',
                  style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchComplaints();
            controller.fetchStats();
          },
          child: ListView.builder(
            padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtil.responsivePadding(context),
                vertical: 16),
            itemCount: complaintsList.length,
            itemBuilder: (context, index) {
              return ComplaintCard(
                complaint: complaintsList[index],
                onTap: () =>
                    _showComplaintDetails(context, complaintsList[index]),
              );
            },
          ),
        );
      }),
    );
  }

  void _showComplaintDetails(BuildContext context, Complaint complaint) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => ComplaintDetailsSheet(
          complaint: complaint,
          scrollController: scrollController,
        ),
      ),
    );
  }
}
