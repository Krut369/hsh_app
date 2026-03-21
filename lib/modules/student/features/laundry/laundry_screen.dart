import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/orders/select_items_screen.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';

class LaundryScreen extends StatelessWidget {
  const LaundryScreen({super.key});

  LaundryController get controller => Get.find<LaundryController>();

  void _openSelectItemsScreen(BuildContext context) {
    // Generate order ID and Date
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

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Obx(() {
        final currentFilter = controller.filter.value;
        return AlertDialog(
          title: const Text('Filter Orders'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('All'),
                value: 'All',
                groupValue: currentFilter,
                onChanged: (value) {
                  if (value != null) controller.setFilter(value);
                  Navigator.of(context).pop();
                },
              ),
              ...OrderStatus.values.map((status) => RadioListTile<String>(
                    title: Text(status.label),
                    value: status.label,
                    groupValue: currentFilter,
                    onChanged: (value) {
                      if (value != null) controller.setFilter(value);
                      Navigator.of(context).pop();
                    },
                  )),
            ],
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Laundry',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Obx(() => ActionChip(
                  avatar:
                      Icon(Icons.filter_list, size: 16, color: scheme.primary),
                  label: Text(
                    controller.filter.value,
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide.none,
                  onPressed: () => _showFilterDialog(context),
                )),
          ),
        ],
      ),
      body: Obx(() {
        final currentFilter = controller.filter.value;
        final allOrders = controller.orders;

        final orders = allOrders.where((o) {
          if (currentFilter == 'All') return true;
          return o.status.label == currentFilter;
        }).toList();

        if (orders.isEmpty) {
          return _buildEmptyState(context, scheme, textTheme);
        }

        return ListView.builder(
          padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildOrderCard(context, order),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSelectItemsScreen(context),
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, LaundryOrderEntity order) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => OrderDetailsScreen(order: order),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM d, yyyy').format(order.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatItem(
                    Icons.grid_view_rounded, 'Items', '${order.totalItems}'),
                _buildStatItem(Icons.tag, 'ID', order.orderId),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[400]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: status.backgroundColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          color: status.textColor,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, ColorScheme scheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_laundry_service_outlined,
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
            'Tap the + button to place a new order.',
            style: textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
