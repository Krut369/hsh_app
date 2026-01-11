import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:hsh_app/models/laundry_order_model.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_components.dart';

class OrderDetailsScreen extends ConsumerWidget {
  final LaundryOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Order Info Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              elevation: 4,
              shadowColor: scheme.shadow.withOpacity(0.2),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    OrderInfoRow(label: 'Order ID', value: order.orderId),
                    const Divider(height: 32),
                    OrderInfoRow(
                      label: 'Date',
                      value: DateFormat('MMM dd, yyyy').format(order.date),
                    ),
                    const Divider(height: 32),
                    OrderInfoRow(
                      label: 'Status',
                      trailing: StatusTag(status: order.status),
                    ),
                    const Divider(height: 32),
                    OrderInfoRow(label: 'Total Items', value: '${order.totalItems}'),
                    if (order.note != null && order.note!.isNotEmpty) ...[
                      const Divider(height: 32),
                      OrderInfoRow(label: 'Note', value: order.note!),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // Laundry Items Header
            Text(
              'Laundry Items',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: scheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),

            // Items List
            if (order.items.isEmpty)
              _buildEmptyState(context)
            else
              ...order.items.map((item) => LaundryItemTile(item: item)),

            const SizedBox(height: 48),

            // Action Button
            CustomButton(
              text: 'Reorder',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reorder functionality coming soon!')),
                );
              },
              backgroundColor: scheme.primary,
              textColor: scheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              borderRadius: 16.0,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 48, color: scheme.onSurfaceVariant.withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(
            'No specific items listed.',
            style: textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
