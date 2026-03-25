import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uitoolkit/uitoolkit.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/status_update_sheet.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:hsh_app/modules/laundry/presentation/widgets/home/laundry_card.dart';

class LaundryDetailScreen extends StatefulWidget {
  const LaundryDetailScreen({super.key});

  @override
  State<LaundryDetailScreen> createState() => _LaundryDetailScreenState();
}

class _LaundryDetailScreenState extends State<LaundryDetailScreen> {
  final LaundryController controller = Get.find<LaundryController>();
  DateTime selectedDate = DateTime.now();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showModernSheet(
      context: context,
      title: 'Filters',
      clearAllText: 'Clear all',
      onClearAll: () {
        controller.setFilter('All');
        setState(() => selectedDate = DateTime.now());
        Get.back();
      },
      actionText: 'Apply Filters',
      onAction: () => Get.back(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ModernText('Date', fontWeight: FontWeight.bold),
          const SizedBox(height: 12),
          ModernDateField(
            onDateSelected: (date) => setState(() => selectedDate = date),
          ),
          const SizedBox(height: 24),
          const ModernText('Status', fontWeight: FontWeight.bold),
          const SizedBox(height: 16),
          Obx(() {
            final statuses = [
              'All',
              'Requested',
              'In Progress',
              'Ready for Pickup',
              'Delivered',
            ];
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: statuses.map((status) {
                final isSelected = controller.filter.value == status;
                return GestureDetector(
                  onTap: () => controller.setFilter(status),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          status,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showUpdateStatusSheet(LaundryOrderEntity order) {
    showModernSheet(
      context: context,
      title: 'Update Status',
      child: ModernStatusUpdateSheet(
        currentStatus: order.status,
        onStatusSelected: (newStatus) {
          controller.updateOrderStatus(order.id, newStatus);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      appBar: ModernAppBar(
        title: 'Laundry Orders',
        onSearchPressed: () {
          setState(() {
            _isSearchVisible = !_isSearchVisible;
            if (!_isSearchVisible) _searchController.clear();
          });
        },
        onFilterPressed: _showFilterDialog,
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ModernSearchField(
                hint: 'Search by Order ID...',
                onChanged: (val) => setState(() {}),
                controller: _searchController,
                onFilterPressed: _showFilterDialog,
              ),
            ),
          Expanded(
            child: Obx(() {
              final currentFilter = controller.filter.value;
              final searchQuery = _searchController.text.toLowerCase();
              final allOrders = controller.orders;

              final filteredRequests = allOrders.where((order) {
                bool matchesStatus = true;
                if (currentFilter != 'All') {
                  if (currentFilter == 'Requested' &&
                      order.status != OrderStatus.requested)
                    matchesStatus = false;
                  if (currentFilter == 'In Progress' &&
                      order.status != OrderStatus.inProgress)
                    matchesStatus = false;
                  if (currentFilter == 'Ready for Pickup' &&
                      order.status != OrderStatus.readyForPickup)
                    matchesStatus = false;
                  if (currentFilter == 'Delivered' &&
                      order.status != OrderStatus.completed)
                    matchesStatus = false;
                }

                final matchesSearch = order.orderId.toLowerCase().contains(
                  searchQuery,
                );
                return matchesStatus && (searchQuery.isEmpty || matchesSearch);
              }).toList();

              if (controller.isLoading.value && allOrders.isEmpty) {
                return const Center(child: ModernLoader());
              }

              if (filteredRequests.isEmpty) {
                return const Center(
                  child: Text(
                    "No orders found",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  ResponsiveUtil.responsivePadding(context),
                  16,
                  ResponsiveUtil.responsivePadding(context),
                  80,
                ),
                itemCount: filteredRequests.length,
                itemBuilder: (context, index) {
                  final order = filteredRequests[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: LaundryCard(
                      order: order,
                      onTap: () {
                        context.push('/laundry/order-detail', extra: order);
                      },
                      onActionTap: () => _showUpdateStatusSheet(order),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
