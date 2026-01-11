import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:hsh_app/models/laundry_order_model.dart';
import 'package:hsh_app/providers/laundry_order_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/orders/select_items_screen.dart';

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

  void _openSelectItemsScreen(BuildContext context) {
    final DateTime orderDate = DateTime.now();
    final String orderId =
        '#ORD${DateFormat('yyyyMMdd').format(orderDate)}${(const Uuid().v4().hashCode % 10000).abs()}';

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => SelectItemsScreen(
          orderId: orderId,
          orderDate: orderDate,
        ),
      ),
    );
  }

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
      child: Text(
        text,
        style: textStyle?.copyWith(color: textColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(laundryOrderListProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtil.responsivePadding(context),
          vertical: ResponsiveUtil.verticalSpacing(context),
        ),
        child: orders.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_laundry_service,
                size: ResponsiveUtil.responsiveIconSize(context, 80),
                color: scheme.onSurface.withOpacity(0.1),
              ),
              const SizedBox(height: 16),
              Text(
                'No laundry orders yet!',
                style: textTheme.titleMedium?.copyWith(
                  color: scheme.onSurface.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap below to place a new order.',
                style: textTheme.bodySmall?.copyWith(
                  color: scheme.onSurface.withOpacity(0.4),
                ),
              ),
            ],
          ),
        )
            : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => OrderDetailsScreen(order: order),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.only(
                  bottom: ResponsiveUtil.verticalSpacing(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order ID: ${order.orderId}',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStatusTag(context, order.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateFormat('MMM d, yyyy').format(order.date)}',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Items: ${order.totalItems}',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Service: ${order.serviceType}',
                        style: textTheme.bodySmall?.copyWith(
                          color: scheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
        child: CustomButton(
          text: 'New Laundry Order',
          onPressed: () => _openSelectItemsScreen(context),
          borderRadius: 30,
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: scheme.primary,
        ),
      ),
    );
  }
}
