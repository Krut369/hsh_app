import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/laundry_item_model.dart';
import '../../../models/laundry_order_model.dart';
import '../../../providers/laundry_order_provider.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/utils/responsive_util.dart';

class SelectItemsScreen extends ConsumerStatefulWidget {
  final String orderId;
  final DateTime orderDate;

  const SelectItemsScreen({
    super.key,
    required this.orderId,
    required this.orderDate,
  });

  @override
  ConsumerState<SelectItemsScreen> createState() => _SelectItemsScreenState();
}

class _SelectItemsScreenState extends ConsumerState<SelectItemsScreen> {
  final Uuid _uuid = const Uuid();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    ref.read(selectableLaundryItemsProvider.notifier).resetItems();
    super.dispose();
  }

  int _calculateTotalItems(List<LaundryItem> items) {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  String _getCombinedServiceType(List<LaundryItem> items) {
    final Set<LaundryServiceType> services = {};
    for (var item in items) {
      if (item.quantity > 0) {
        services.add(item.selectedService);
      }
    }

    if (services.contains(LaundryServiceType.both) ||
        (services.contains(LaundryServiceType.wash) &&
            services.contains(LaundryServiceType.press))) {
      return 'Wash & Press';
    } else if (services.contains(LaundryServiceType.wash)) {
      return 'Wash';
    } else if (services.contains(LaundryServiceType.press)) {
      return 'Press';
    }
    return 'N/A';
  }

  void _placeOrder() {
    final selectedItems = ref
        .read(selectableLaundryItemsProvider)
        .where((item) => item.quantity > 0)
        .toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one item.')),
      );
      return;
    }

    final totalItems = _calculateTotalItems(selectedItems);
    final serviceType = _getCombinedServiceType(selectedItems);

    final newOrder = LaundryOrder(
      id: _uuid.v4(),
      orderId: widget.orderId,
      date: widget.orderDate,
      totalItems: totalItems,
      serviceType: serviceType,
      status: OrderStatus.inProgress,
      items: selectedItems,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    ref.read(laundryOrderListProvider.notifier).addOrder(newOrder);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(selectableLaundryItemsProvider);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Items',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: scheme.onPrimary,
          ),
        ),
        backgroundColor: scheme.primaryContainer,
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: scheme.onPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: ResponsiveUtil.responsivePadding(context) + 80,
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...items.map((item) {
                    return Card(
                      margin: EdgeInsets.only(bottom: ResponsiveUtil.verticalSpacing(context)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: scheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(item.icon, color: scheme.primary, size: 24),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: scheme.surfaceVariant.withOpacity(0.4),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 20),
                                        onPressed: () {
                                          if (item.quantity > 0) {
                                            ref.read(selectableLaundryItemsProvider.notifier).updateItem(
                                              item.copyWith(quantity: item.quantity - 1),
                                            );
                                          }
                                        },
                                        visualDensity: VisualDensity.compact,
                                      ),
                                      Text('${item.quantity}', style: textTheme.bodyLarge),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 20),
                                        onPressed: () {
                                          ref.read(selectableLaundryItemsProvider.notifier).updateItem(
                                            item.copyWith(quantity: item.quantity + 1),
                                          );
                                        },
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Service Type',
                              style: textTheme.labelLarge?.copyWith(color: scheme.onSurface.withOpacity(0.7)),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildServiceButton(context, item, LaundryServiceType.wash, 'Wash', scheme.primary),
                                const SizedBox(width: 8),
                                _buildServiceButton(context, item, LaundryServiceType.press, 'Press', Colors.deepPurple),
                                const SizedBox(width: 8),
                                _buildServiceButton(context, item, LaundryServiceType.both, 'Both', Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      labelText: 'Add a note (optional)',
                      hintText: 'e.g., Handle with care, Urgent',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.note_add_outlined),
                    ),
                    maxLines: 3,
                    minLines: 1,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: CustomButton(
              text: 'Place Order',
              onPressed: _placeOrder,
              backgroundColor: scheme.primary,
              borderRadius: 15.0,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceButton(
      BuildContext context,
      LaundryItem item,
      LaundryServiceType type,
      String label,
      Color color,
      ) {
    final isSelected = item.selectedService == type;

    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          ref.read(selectableLaundryItemsProvider.notifier).updateItem(item.copyWith(selectedService: type));
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? color.withOpacity(0.1) : Colors.transparent,
          side: BorderSide(color: isSelected ? color : Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? color : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
          ),
        ),
      ),
    );
  }
}
