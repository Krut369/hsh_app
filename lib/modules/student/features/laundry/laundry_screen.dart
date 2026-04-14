import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui hide AppColors;
import 'package:uuid/uuid.dart';

import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/orders/select_items_screen.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/laundry/widgets/laundry_card.dart';
// import 'package:flutter/material.dart' as ui;

class LaundryScreen extends StatelessWidget {
  const LaundryScreen({super.key});

  LaundryController get controller => Get.find<LaundryController>();

  void _openSelectItemsScreen(BuildContext context) {
    final DateTime orderDate = DateTime.now();
    final String orderId =
        '#ORD${DateFormat('yyyyMMdd').format(orderDate)}${(const Uuid().v4().hashCode % 10000).abs()}';

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (ctx) => SelectItemsScreen(
          orderId: orderId,
          orderDate: orderDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: AppColors.mainBackground,
      floatingActionButton: FloatingActionButton(
        heroTag: 'laundry_fab',
        onPressed: () => _openSelectItemsScreen(context),
        backgroundColor: AppColors.headerBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // Custom Header
          _buildHeader(context),
          // Order List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentFilter = controller.filter.value;
              final filteredOrders = controller.orders.where((o) {
                if (currentFilter == 'All') return true;
                return o.status.label == currentFilter;
              }).toList();

              if (filteredOrders.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.fetchOrders();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return LaundryCard(
                      order: order,
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (ctx) => OrderDetailsScreen(order: order),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 24,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ui.ModernText(
            "Laundry",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showFilterDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_alt_outlined,
                    color: AppColors.headerBlue, size: 14),
                const SizedBox(width: 8),
                ui.ModernText(
                  controller.filter.value,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                ),
              ],
            ),
          ),
        ));
  }

  void _showFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ui.ModernText(
              "Filter Orders",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.headerBlue,
            ),
            const SizedBox(height: 20),
            _buildFilterOption("All"),
            ...OrderStatus.values
                .map((status) => _buildFilterOption(status.label)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label) {
    return Obx(() {
      final isSelected = controller.filter.value == label;
      return ListTile(
        onTap: () {
          controller.setFilter(label);
          Get.back();
        },
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? AppColors.pendingBlue : Colors.grey,
        ),
        title: ui.ModernText(
          label,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: AppColors.headerBlue,
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Icon(Icons.local_laundry_service_outlined,
                size: 64, color: Colors.grey[300]),
          ),
          const SizedBox(height: 24),
          const ui.ModernText(
            "No laundry orders yet!",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
          const SizedBox(height: 8),
          ui.ModernText(
            "Tap the + button to place a new order.",
            fontSize: 14,
            color: Colors.grey[500]!,
          ),
        ],
      ),
    );
  }
}
