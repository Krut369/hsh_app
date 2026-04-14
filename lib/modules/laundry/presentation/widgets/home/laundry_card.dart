import 'package:flutter/material.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:intl/intl.dart';

class LaundryCard extends StatelessWidget {
  final LaundryOrderEntity order;
  final VoidCallback onTap;
  final VoidCallback onActionTap;

  const LaundryCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine colors and labels based on status
    Color statusColor;
    String actionLabel;
    bool isFinished = order.status == OrderStatus.completed ||
        order.status == OrderStatus.cancelled;

    switch (order.status) {
      case OrderStatus.requested:
        statusColor = Colors.blueGrey;
        actionLabel = 'Accept';
        break;
      case OrderStatus.inProgress:
        statusColor = Colors.orange;
        actionLabel = 'Update Status';
        break;
      case OrderStatus.readyForPickup:
        statusColor = Colors.purple;
        actionLabel = 'Mark Delivered';
        break;
      case OrderStatus.completed:
        statusColor = Colors.teal;
        actionLabel = 'Finished';
        break;
      case OrderStatus.cancelled:
        statusColor = Colors.red;
        actionLabel = 'Cancelled';
        break;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: ModernActionCard(
          title: 'Student Name',
          subtitle: '${order.orderId} • ${order.totalItems} Items',
          badgeText: order.status.label,
          badgeColor: statusColor,
          statusIndicatorColor: statusColor,
          footerLabel: DateFormat('MMM d, h:mm a').format(order.date),
          buttonText: actionLabel,
          onButtonPressed: isFinished ? null : onActionTap,
          onTap: null, // Managed by parent InkWell
        ),
      ),
    );
  }
}
