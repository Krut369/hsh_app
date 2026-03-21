import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class SelectItemsScreen extends StatefulWidget {
  final String orderId;
  final DateTime orderDate;

  const SelectItemsScreen({
    super.key,
    required this.orderId,
    required this.orderDate,
  });

  @override
  State<SelectItemsScreen> createState() => _SelectItemsScreenState();
}

class _SelectItemsScreenState extends State<SelectItemsScreen> {
  final LaundryController controller = Get.find<LaundryController>();
  final Uuid _uuid = const Uuid();
  final TextEditingController _noteController = TextEditingController();

  // Selected tab index (category)
  int _selectedIndex = 0;

  // Basket state: ItemID -> { ServiceType -> Quantity }
  final Map<String, Map<LaundryServiceType, int>> _basket = {};

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int _getQuantity(String itemId, LaundryServiceType type) {
    return _basket[itemId]?[type] ?? 0;
  }

  void _updateQuantity(String itemId, LaundryServiceType type, int delta) {
    setState(() {
      final itemMap = _basket.putIfAbsent(itemId, () => {});
      final currentQty = itemMap[type] ?? 0;
      final newQty = currentQty + delta;

      if (newQty <= 0) {
        itemMap.remove(type);
        if (itemMap.isEmpty) {
          _basket.remove(itemId);
        }
      } else {
        itemMap[type] = newQty;
      }
    });
  }

  int _getTotalForItem(String itemId) {
    final itemMap = _basket[itemId];
    if (itemMap == null) return 0;
    return itemMap.values.fold(0, (sum, qty) => sum + qty);
  }

  int _getBasketTotal() {
    int total = 0;
    for (var itemMap in _basket.values) {
      total += itemMap.values.fold(0, (sum, qty) => sum + qty);
    }
    return total;
  }

  String _getCombinedServiceTypeString() {
    final Set<LaundryServiceType> services = {};
    for (var itemMap in _basket.values) {
      services.addAll(itemMap.keys);
    }

    if (services.isEmpty) return 'N/A';

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
    if (_basket.isEmpty) {
      Get.snackbar('Error', 'Please select at least one item.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final List<LaundryItemEntity> orderItems = [];
    final allItems = controller.selectableItems;

    _basket.forEach((itemId, serviceMap) {
      final originalItem = allItems.firstWhere((i) => i.id == itemId,
          orElse: () => allItems.first);

      serviceMap.forEach((serviceType, qty) {
        if (qty > 0) {
          orderItems.add(originalItem.copyWith(
            quantity: qty,
            selectedService: serviceType,
          ));
        }
      });
    });

    final totalItems = _getBasketTotal();
    final serviceTypeStr = _getCombinedServiceTypeString();

    final newOrder = LaundryOrderEntity(
      id: _uuid.v4(),
      orderId: widget.orderId,
      date: widget.orderDate,
      totalItems: totalItems,
      serviceType: serviceTypeStr,
      status: OrderStatus.requested,
      items: orderItems,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    controller.addOrder(newOrder);

    Get.snackbar('Success', 'Order placed successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white);

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.selectableItems;

      if (items.isEmpty) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final selectedItem = items[_selectedIndex];
      final totalInBasket = _getTotalForItem(selectedItem.id);

      return Scaffold(
        backgroundColor: AppColors.surface,
        appBar: CustomAppBar(
          title: 'Select Items',
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Column(
          children: [
            // 1. Categories Tabs
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = index == _selectedIndex;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: isSelected
                              ? const Border(
                                  bottom: BorderSide(
                                      color: AppColors.primary, width: 2))
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                            color: AppColors.primary
                                                .withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 4))
                                      ]
                                    : [],
                              ),
                              child: Icon(item.icon,
                                  color:
                                      isSelected ? Colors.white : Colors.grey,
                                  size: 24),
                            ),
                            const SizedBox(height: 8),
                            Text(item.name,
                                style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey,
                                    fontSize: 12)),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // 2. Main Item Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10))
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.dry_cleaning,
                                    size: 40, color: AppColors.secondary),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      selectedItem.name,
                                      style: AppFonts.heading2(context),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Total in basket: $totalInBasket Items',
                                      style: AppFonts.bodyRegular(context)
                                          .copyWith(
                                              color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // 3. Service Options Rows
                          Obx(() => Column(
                                children: [
                                  _buildServiceRow(
                                      selectedItem,
                                      LaundryServiceType.wash,
                                      'Wash Only',
                                      '₹${controller.washPrice.value.toStringAsFixed(0)} per unit',
                                      AppColors.primary,
                                      Icons.water_drop),
                                  const SizedBox(height: 20),
                                  _buildServiceRow(
                                      selectedItem,
                                      LaundryServiceType.press,
                                      'Press Only',
                                      '₹${controller.pressPrice.value.toStringAsFixed(0)} per unit',
                                      AppColors.primary,
                                      Icons.iron),
                                  const SizedBox(height: 20),
                                  _buildServiceRow(
                                      selectedItem,
                                      LaundryServiceType.both,
                                      'Wash & Press',
                                      '₹${controller.bothPrice.value.toStringAsFixed(0)} per unit',
                                      AppColors.primary,
                                      Icons.dry_cleaning),
                                ],
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        hintText: 'Add a note (e.g. starch levels)',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.all(16),
                        prefixIcon:
                            const Icon(Icons.edit_note, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_getBasketTotal() > 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '${_getBasketTotal()} items selected',
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: Text('Add Laundry',
                            style: AppFonts.buttonText(context)),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildServiceRow(LaundryItemEntity item, LaundryServiceType type,
      String title, String subtitle, Color color, IconData icon) {
    final qty = _getQuantity(item.id, type);

    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppFonts.bodyBold(context)),
              Text(subtitle,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
        Row(
          children: [
            _buildStepperButton(
                Icons.remove, () => _updateQuantity(item.id, type, -1),
                isAdd: false),
            SizedBox(
              width: 32,
              child: Text('$qty',
                  textAlign: TextAlign.center,
                  style: AppFonts.bodyBold(context)),
            ),
            _buildStepperButton(
                Icons.add, () => _updateQuantity(item.id, type, 1),
                isAdd: true),
          ],
        )
      ],
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap,
      {required bool isAdd}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
          border: isAdd ? null : Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: isAdd ? Colors.white : Colors.grey),
      ),
    );
  }
}
