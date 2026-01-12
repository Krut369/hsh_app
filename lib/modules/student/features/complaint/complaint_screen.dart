import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';

import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/providers/complaint_provider.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_card.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_details_sheet.dart';

class ComplaintScreen extends ConsumerWidget {
  const ComplaintScreen({super.key});

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.read(complaintFilterProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.filterComplaints,
            style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ComplaintStatus?>(
              title: const Text('All'),
              value: null,
              groupValue: currentFilter,
              onChanged: (value) {
                ref.read(complaintFilterProvider.notifier).state = value;
                context.pop();
              },
            ),
            ...ComplaintStatus.values.map((status) {
              return RadioListTile<ComplaintStatus?>(
                title: Text(status.label),
                value: status,
                groupValue: currentFilter,
                onChanged: (value) {
                  ref.read(complaintFilterProvider.notifier).state = value;
                  context.pop();
                },
              );
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: AppText.complaint,
        showNotificationIcon: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ActionChip(
              avatar: Icon(Icons.filter_list, size: 16, color: scheme.primary),
              label: Text(
                filter?.label ?? 'All',
                style: TextStyle(
                    color: scheme.primary, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              side: BorderSide.none,
              onPressed: () => _showFilterDialog(context, ref),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/student/complaint/add');
        },
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: complaints.isEmpty
                ? Center(
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
                          'No ${filter?.label.toLowerCase() ?? ''} complaints found',
                          style: textTheme.titleMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Have an issue? Raise a ticket now.',
                          style: textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtil.responsivePadding(context)),
                    itemCount: complaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintCard(
                        complaint: complaints[index],
                        onTap: () =>
                            _showComplaintDetails(context, complaints[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
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
        builder: (_, controller) => ComplaintDetailsSheet(
          complaint: complaint,
          scrollController: controller,
        ),
      ),
    );
  }
}

