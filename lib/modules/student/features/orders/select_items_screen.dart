import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:uitoolkit/uitoolkit.dart' as ui;

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
  final TextEditingController _noteController = TextEditingController();

  int _selectedIndex = 0;
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

  int _getBasketTotal() {
    int total = 0;
    for (var itemMap in _basket.values) {
      total += itemMap.values.fold(0, (sum, qty) => sum + qty);
    }
    return total;
  }

  int _getBasketTotalForItem(String itemId) {
    if (!_basket.containsKey(itemId)) return 0;
    return _basket[itemId]!.values.fold(0, (sum, qty) => sum + qty);
  }

  double _getTotalPriceForItem(String itemId) {
    if (!_basket.containsKey(itemId)) return 0.0;
    double total = 0;
    final serviceMap = _basket[itemId]!;
    for (var type in serviceMap.keys) {
      final qty = serviceMap[type]!;
      if (type == LaundryServiceType.wash) {
        total += qty * controller.washPrice.value;
      } else if (type == LaundryServiceType.press) {
        total += qty * controller.pressPrice.value;
      } else if (type == LaundryServiceType.both) {
        total += qty * controller.bothPrice.value;
      }
    }
    return total;
  }

  double _getTotalPrice() {
    double total = 0;
    for (var itemId in _basket.keys) {
      total += _getTotalPriceForItem(itemId);
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

  Future<void> _placeOrder() async {
    if (_basket.isEmpty) {
      Get.snackbar('Error', 'Please select at least one item.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    // Support multiple items of same category but different service types
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

    final serviceTypeStr = _getCombinedServiceTypeString();

    final order = LaundryOrderEntity(
      id: '',
      orderId: '',
      date: DateTime.now(),
      totalItems: _getBasketTotal(),
      serviceType: serviceTypeStr,
      status: OrderStatus.requested,
      items: orderItems,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    // Call the controller's submit method which uses the CreateOrderUseCase
    await controller.submitOrderFromItems(order);
  }

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: const Color(0xFFF3F7F9),
      body: Obx(() {
        final items = controller.selectableItems;
        if (items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final selectedItem = items[_selectedIndex];

        return Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category List
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isSelected = index == _selectedIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedIndex = index),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.headerBlue
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: Icon(
                                      _getCategoryIcon(item.name),
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF94A3B8),
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ui.ModernText(
                                    item.name,
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.headerBlue
                                        : const Color(0xFF64748B),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    height: 2,
                                    width: 30,
                                    color: isSelected ? AppColors.headerBlue : Colors.transparent,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 10),
                    // Container 1: Summary of Selected Category
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _getCategoryIcon(selectedItem.name),
                              color: AppColors.headerBlue,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ui.ModernText(
                                      selectedItem.name,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.headerBlue,
                                    ),
                                    if (_getBasketTotalForItem(selectedItem.id) > 0)
                                      ui.ModernText(
                                        "₹${_getTotalPriceForItem(selectedItem.id).toStringAsFixed(2)}",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.headerBlue,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ui.ModernText(
                                  "Total in basket:  ${_getBasketTotalForItem(selectedItem.id)} Items",
                                  fontSize: 14,
                                  color: const Color(0xFF64748B),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Container 2: Service Cards
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          _buildServiceCard(
                            selectedItem,
                            LaundryServiceType.wash,
                            "Wash Only",
                            controller.washPrice.value,
                          ),
                          const SizedBox(height: 20),
                          _buildServiceCard(
                            selectedItem,
                            LaundryServiceType.press,
                            "Press Only",
                            controller.pressPrice.value,
                          ),
                          const SizedBox(height: 20),
                          _buildServiceCard(
                            selectedItem,
                            LaundryServiceType.both,
                            "Wash & Press",
                            controller.bothPrice.value,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Container 3: Notes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            )
                          ]
                        ),
                        child: TextField(
                          controller: _noteController,
                          decoration: InputDecoration(
                            hintText: 'Add a note (e.g. starch levels)',
                            hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8), fontSize: 14),
                            prefixIcon: const Icon(Icons.sort, color: Color(0xFF94A3B8)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Container 4: Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Obx(() {
                        final totalPrice = _getTotalPrice();
                        return SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : _placeOrder,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.headerBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const ui.ModernText(
                                        'Add Laundry',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      if (totalPrice > 0)
                                        ui.ModernText(
                                          '  •  ₹${totalPrice.toStringAsFixed(2)}',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 14,
        left: 16,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          const ui.ModernText(
            "Select Items",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(LaundryItemEntity item, LaundryServiceType type,
      String title, double price) {
    final qty = _getQuantity(item.id, type);

    IconData getServiceIcon() {
      if (type == LaundryServiceType.wash) return Icons.water_drop_outlined;
      if (type == LaundryServiceType.press) return Icons.air_outlined;
      return Icons.checkroom_outlined;
    }

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Color(0xFFEFF6FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            getServiceIcon(),
            color: AppColors.headerBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ui.ModernText(
                title,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.headerBlue,
              ),
              const SizedBox(height: 2),
              ui.ModernText(
                "₹${price.toStringAsFixed(2)} per unit",
                fontSize: 12,
                color: const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
        // Stepper
        Row(
          children: [
            _buildStepperButton(Icons.remove_rounded,
                () => _updateQuantity(item.id, type, -1), false),
            SizedBox(
              width: 32,
              child: ui.ModernText(
                "$qty",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.headerBlue,
                textAlign: TextAlign.center,
              ),
            ),
            _buildStepperButton(Icons.add_rounded,
                () => _updateQuantity(item.id, type, 1), true),
          ],
        ),
      ],
    );
  }

  Widget _buildStepperButton(IconData icon, VoidCallback onTap, bool isAdd) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: isAdd ? AppColors.headerBlue : Colors.white,
          shape: BoxShape.circle,
          border: isAdd ? null : Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isAdd ? Colors.white : const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('shirt')) return Icons.dry_cleaning_rounded;
    if (lower.contains('pant') || lower.contains('short')) return Icons.checkroom_rounded;
    if (lower.contains('jacket')) return Icons.checkroom_rounded;
    if (lower.contains('towel')) return Icons.sanitizer_rounded;
    return Icons.local_laundry_service_rounded;
  }
}
