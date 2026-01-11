import 'package:flutter/material.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/models/laundry_item_model.dart';
import 'package:hsh_app/models/laundry_order_model.dart'; // Needed for OrderStatus

/// A reusable row for displaying label and value in the order details.
class OrderInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final bool isLast;

  const OrderInfoRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Increased spacing
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium?.copyWith(color: color)),
          if (trailing != null)
            trailing!
          else
            Text(
              value ?? '',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
        ],
      ),
    );
  }
}

/// A chip-like widget to display the status of an order.
class StatusTag extends StatelessWidget {
  final OrderStatus status;

  const StatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: textStyle?.copyWith(color: status.textColor),
      ),
    );
  }
}

/// A compact tag to display the service type (Wash, Press, Both).
class ServiceTag extends StatelessWidget {
  final LaundryServiceType serviceType;

  const ServiceTag({super.key, required this.serviceType});

  @override
  Widget build(BuildContext context) {
    final double fontSize = ResponsiveUtil.responsiveFontSize(context, 10);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: serviceType.backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        serviceType.label,
        style: TextStyle(
          color: serviceType.textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// A list tile for a single laundry item.
class LaundryItemTile extends StatelessWidget {
  final LaundryItem item;

  const LaundryItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: scheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: scheme.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Quantity: ${item.quantity}',
                  style: textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          ServiceTag(serviceType: item.selectedService),
        ],
      ),
    );
  }
}
