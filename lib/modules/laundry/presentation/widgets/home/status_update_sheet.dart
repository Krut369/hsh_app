import 'package:flutter/material.dart';
import 'package:uitoolkit/uitoolkit.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

class ModernStatusUpdateSheet extends StatefulWidget {
  final OrderStatus currentStatus;
  final Function(OrderStatus) onStatusSelected;

  const ModernStatusUpdateSheet({
    super.key,
    required this.currentStatus,
    required this.onStatusSelected,
  });

  @override
  State<ModernStatusUpdateSheet> createState() =>
      _ModernStatusUpdateSheetState();
}

class _ModernStatusUpdateSheetState extends State<ModernStatusUpdateSheet> {
  late OrderStatus selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.currentStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModernRadioGroup<OrderStatus>(
          value: selectedStatus,
          onChanged: (v) => setState(() => selectedStatus = v),
          items: [
            const ModernRadioItem(
              value: OrderStatus.requested,
              label: 'Requested',
              color: Colors.blueGrey,
            ),
            const ModernRadioItem(
              value: OrderStatus.inProgress,
              label: 'In Progress',
              color: Colors.orange,
            ),
            const ModernRadioItem(
              value: OrderStatus.readyForPickup,
              label: 'Ready for Pickup',
              color: Colors.purple,
            ),
            const ModernRadioItem(
              value: OrderStatus.completed,
              label: 'Delivered',
              color: Colors.teal,
            ),
            const ModernRadioItem(
              value: OrderStatus.cancelled,
              label: 'Cancelled',
              color: Colors.red,
            ),
          ],
        ),
        const SizedBox(height: 32),
        ModernButton(
          text: 'Confirm',
          onPressed: () {
            widget.onStatusSelected(selectedStatus);
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
