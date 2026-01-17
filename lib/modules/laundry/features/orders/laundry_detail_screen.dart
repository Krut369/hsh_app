import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../models/laundry_order_model.dart';
import '../../../../providers/laundry_order_provider.dart';
import '../../controllers/laundry_filter_provider.dart';

import '../home/widgets/laundry_card.dart';
import '../home/widgets/status_update_sheet.dart';

class LaundryDetailScreen extends ConsumerStatefulWidget {
  const LaundryDetailScreen({super.key});

  @override
  ConsumerState<LaundryDetailScreen> createState() => _LaundryDetailScreenState();
}

class _LaundryDetailScreenState extends ConsumerState<LaundryDetailScreen> {
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final currentFilter = ref.read(laundryFilterProvider);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Filters",
                            style: AppFonts.heading3(context)
                                .copyWith(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            ref.read(laundryFilterProvider.notifier).state = 'All';
                            setState(() {
                              selectedDate = DateTime.now();
                            });
                            setModalState(() {});
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Clear all",
                            style: AppFonts.bodyMedium(context).copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close))
                      ]),
                  const SizedBox(height: 20),

                  // Date Filter
                  Text("Date",
                      style: AppFonts.bodyMedium(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: AppColors.primary,
                                  onPrimary: Colors.white,
                                  onSurface: AppColors.textPrimary,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                          setModalState(() {});
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.surface,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_formatDate(selectedDate),
                                    style: AppFonts.bodyRegular(context)),
                                const Icon(Icons.calendar_today_rounded,
                                    size: 20, color: AppColors.textSecondary)
                              ]))),
                  const SizedBox(height: 20),

                  // Status Filter
                  Text("Status",
                      style: AppFonts.bodyMedium(context)
                          .copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'All',
                      'Requested', // Assuming 'Requested' maps to 'In Progress' or similar in logic
                      'In Progress',
                      'Ready for Pickup',
                      'Delivered'
                    ].map((status) {
                      final isSelected = currentFilter == status;
                      return ChoiceChip(
                        label: Text(status),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          if (selected) {
                            ref.read(laundryFilterProvider.notifier).state = status;
                            setModalState(() {});
                            Navigator.pop(context);
                          }
                        },
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: AppColors.surface,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: isSelected
                                    ? Colors.transparent
                                    : AppColors.border)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showUpdateStatusSheet(LaundryOrder order) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatusUpdateSheet(
            currentStatus: order.status,
            onStatusSelected: (newStatus) {
                final updatedOrder = order.copyWith(status: newStatus);
                ref.read(laundryOrderListProvider.notifier).updateOrder(updatedOrder);
            },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    if (DateUtils.isSameDay(date, DateTime.now())) {
      return "Today, ${DateFormat('MMM d').format(date)}";
    }
    return DateFormat('EEE, MMM d').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(laundryFilterProvider);
    final searchQuery = _searchController.text.toLowerCase();
    final allOrders = ref.watch(laundryOrderListProvider);

    final filteredRequests = allOrders.where((order) {
      // Status Filter Logic (Simplified matching)
      bool matchesStatus = true;
      if (currentFilter != 'All') {
          if (currentFilter == 'Requested' && order.status != OrderStatus.requested) matchesStatus = false;
          if (currentFilter == 'In Progress' && order.status != OrderStatus.inProgress) matchesStatus = false;
          if (currentFilter == 'Ready for Pickup' && order.status != OrderStatus.readyForPickup) matchesStatus = false;
          if (currentFilter == 'Delivered' && order.status != OrderStatus.completed) matchesStatus = false;
      }

      final matchesSearch = order.orderId.toLowerCase().contains(searchQuery) ||
          // order.studentName.toLowerCase().contains(searchQuery) || // If you had student name
          false; // placeholder
      return matchesStatus && (searchQuery.isEmpty || matchesSearch); // Search logic
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Laundry',
          style: AppFonts.heading2(context).copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchController.clear();
                }
              });
            },
            icon: Icon(
              _isSearchVisible ? Icons.close : Icons.search,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () => _showFilterDialog(),
            child: Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: const BoxDecoration(
                    color: Colors.white12, shape: BoxShape.circle),
                padding: const EdgeInsets.all(8),
                child: currentFilter != 'All'
                    ? const Badge(
                        child: Icon(
                        Icons.filter_list_rounded,
                        color: Colors.white,
                        size: 24,
                      ))
                    : const Icon(
                        Icons.filter_list_rounded,
                        color: Colors.white,
                        size: 24,
                      )),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by Order ID...',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
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
                          // Define route for detail
                          // For now, using direct navigation as in original, 
                          // but typically this should be GoRouter path like: 
                          // context.push('/laundry/orders/${order.id}', extra: order);
                          // But the file structure implies direct import usage for now or GoRouter config update.
                          // Assuming explicit route not yet set up for ID-based nav in 'app_router.dart', passing object via extra.
                          context.push('/laundry/order-detail', extra: order);
                      },
                      onActionTap: () => _showUpdateStatusSheet(order),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
