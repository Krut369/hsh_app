import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';
import '../../../widgets/custom_card.dart'; // MyCard

class ComplainHomeScreen extends ConsumerWidget {
  const ComplainHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final total = ref.watch(totalComplaintCountProvider);

    // Card data
    final cardData = [
      {
        'status': ComplaintStatus.pending,
        'icon': Icons.schedule,
      },
      {
        'status': ComplaintStatus.underReview,
        'icon': Icons.search,
      },
      {
        'status': ComplaintStatus.awaitingFeedback,
        'icon': Icons.feedback,
      },
      {
        'status': ComplaintStatus.resolved,
        'icon': Icons.check_circle,
      },
    ];

    final crossAxisCount = ResponsiveUtil.responsiveGridCount(context);
    final spacing = ResponsiveUtil.horizontalSpacing(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Complaints ($total)', style: AppFonts.heading2(context)),
      ),
      body: Padding(
        padding: padding,
        child: GridView.count(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: cardData.map((data) {
            final status = data['status'] as ComplaintStatus;
            final icon = data['icon'] as IconData;
            return _statusCard(context, ref, status, icon);
          }).toList(),
        ),
      ),
    );
  }

  Widget _statusCard(
      BuildContext context,
      WidgetRef ref,
      ComplaintStatus status,
      IconData icon,
      ) {
    final count = ref.watch(complaintCountByStatusProvider(status));
    final selected = ref.watch(complaintFilterProvider) == status;

    return MyCard(
      icon: icon,
      text: '${status.label}: $count',
      isSelected: selected,
      onTap: () {
        ref.read(complaintFilterProvider.notifier).state = status;
      },
    );
  }
}
