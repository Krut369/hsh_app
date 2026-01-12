import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:hsh_app/models/laundry_order_model.dart';
import 'package:hsh_app/providers/laundry_order_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/orders/select_items_screen.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';

// Local state for filter
final laundryFilterProvider = StateProvider<OrderStatus?>((ref) => null);

class LaundryScreen extends ConsumerWidget {
  const LaundryScreen({super.key});

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

  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentFilter = ref.watch(laundryFilterProvider);
          return AlertDialog(
            title: const Text('Filter Orders'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<OrderStatus?>(
                  title: const Text('All'),
                  value: null,
                  groupValue: currentFilter,
                  onChanged: (value) {
                    ref.read(laundryFilterProvider.notifier).state = value;
                    Navigator.of(context).pop();
                  },
                ),
                ...OrderStatus.values
                    .map((status) => RadioListTile<OrderStatus?>(
                          title: Text(status.label),
                          value: status,
                          groupValue: currentFilter,
                          onChanged: (value) {
                            ref.read(laundryFilterProvider.notifier).state =
                                value;
                            Navigator.of(context).pop();
                          },
                        )),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allOrders = ref.watch(laundryOrderListProvider);
    final filter = ref.watch(laundryFilterProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final orders = filter == null
        ? allOrders
        : allOrders.where((o) => o.status == filter).toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Laundry',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ActionChip(
              avatar: Icon(Icons.filter_list, size: 16, color: scheme.primary),
              label: Text(
                filter?.label ?? 'All',
                style: TextStyle(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              side: BorderSide.none,
              onPressed: () => _showFilterDialog(context, ref),
            ),
          ),
        ],
      ),
      body: orders.isEmpty
          ? _buildEmptyState(context, scheme, textTheme)
          : ListView.builder(
              padding:
                  EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildOrderCard(context, order),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openSelectItemsScreen(context),
        backgroundColor: scheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, LaundryOrder order) {
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
                      order.serviceType, // "Wash & Press"
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
