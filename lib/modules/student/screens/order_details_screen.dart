import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/laundry_item_model.dart';
import '../../../models/laundry_order_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/utils/responsive_util.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final LaundryOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  Widget _buildStatusTag(BuildContext context, OrderStatus status) {
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );

    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case OrderStatus.inProgress:
        backgroundColor = Colors.amber.shade100;
        textColor = Colors.amber.shade800;
        text = 'In Progress';
        break;
      case OrderStatus.completed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Completed';
        break;
      case OrderStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        text = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: textStyle?.copyWith(color: textColor)),
    );
  }

  Widget _buildItemServiceTag(BuildContext context, LaundryServiceType serviceType) {
    final double fontSize = ResponsiveUtil.responsiveFontSize(context, 10);

    Color backgroundColor;
    Color textColor;
    String text;

    switch (serviceType) {
      case LaundryServiceType.wash:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        text = 'Wash';
        break;
      case LaundryServiceType.press:
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        text = 'Press';
        break;
      case LaundryServiceType.both:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        text = 'Both';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String? value, {Widget? trailing}) {
    final textTheme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.bodyMedium?.copyWith(color: color)),
          trailing ??
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Order Details',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
              elevation: 6,
              child: Padding(
                padding: EdgeInsets.all(ResponsiveUtil.horizontalSpacing(context) * 2),
                child: Column(
                  children: [
                    _buildInfoRow(context, 'Order ID', order.orderId),
                    const Divider(height: 20),
                    _buildInfoRow(context, 'Date', DateFormat('MMMM dd, yyyy').format(order.date)),
                    const Divider(height: 20),
                    _buildInfoRow(context, 'Status', null, trailing: _buildStatusTag(context, order.status)),
                    const Divider(height: 20),
                    _buildInfoRow(context, 'Total Items', '${order.totalItems}'),
                    const Divider(height: 20),
                    _buildInfoRow(context, 'Service Type', order.serviceType),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Laundry Items',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (order.items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'No specific items listed for this order.',
                    style: textTheme.bodyMedium?.copyWith(color: scheme.onSurface.withOpacity(0.5)),
                  ),
                ),
              )
            else
              ...order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: scheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, color: scheme.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}',
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      _buildItemServiceTag(context, item.selectedService),
                    ],
                  ),
                );
              }).toList(),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Reorder',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reorder functionality coming soon!')),
                );
              },
              backgroundColor: scheme.primary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              borderRadius: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
