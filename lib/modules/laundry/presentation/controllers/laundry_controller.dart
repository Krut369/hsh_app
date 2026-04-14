import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/get_laundry_orders_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/update_order_status_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/create_laundry_order_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/manage_laundry_cost_usecase.dart';

class LaundryController extends GetxController {
  final GetLaundryOrdersUseCase _getOrdersUseCase;
  final UpdateOrderStatusUseCase _updateStatusUseCase;
  final CreateLaundryOrderUseCase _createOrderUseCase;
  final ManageLaundryCostUseCase _costUseCase;

  LaundryController({
    required GetLaundryOrdersUseCase getOrdersUseCase,
    required UpdateOrderStatusUseCase updateStatusUseCase,
    required CreateLaundryOrderUseCase createOrderUseCase,
    required ManageLaundryCostUseCase costUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        _createOrderUseCase = createOrderUseCase,
        _costUseCase = costUseCase;

  // Observables
  final _orders = <LaundryOrderEntity>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final filter = 'All'.obs;
  final tabIndex = 0.obs;

  // Selection logic for student module
  final selectableItems = <LaundryItemEntity>[
    const LaundryItemEntity(id: 's1', name: 'Shirts', icon: Icons.dry_cleaning),
    const LaundryItemEntity(id: 'p1', name: 'Pants', icon: Icons.checkroom),
    const LaundryItemEntity(id: 'ts', name: 'T-Shirts', icon: Icons.dry_cleaning),
    const LaundryItemEntity(id: 'j1', name: 'Jackets', icon: Icons.checkroom),
    const LaundryItemEntity(id: 'sh', name: 'Shorts', icon: Icons.checkroom),
    const LaundryItemEntity(id: 'tw', name: 'Towel', icon: Icons.sanitizer),
    const LaundryItemEntity(id: 'o1', name: 'Others', icon: Icons.devices_other),
  ].obs;

  // Cost Observables
  final washPrice = 10.0.obs;
  final pressPrice = 5.0.obs;
  final bothPrice = 15.0.obs;

  List<LaundryOrderEntity> get orders => _orders;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
    fetchLaundryCost();
  }

  Future<void> fetchOrders() async {
    isLoading.value = true;
    error.value = null;
    try {
      final fetchedOrders = await _getOrdersUseCase.execute();
      var ordersList = fetchedOrders.toList();
      
      if (ordersList.isEmpty) {
        ordersList = [
          LaundryOrderEntity(
            id: 'd1',
            orderId: '#ORD20240612111',
            date: DateTime.now().subtract(const Duration(days: 1)),
            totalItems: 5,
            serviceType: 'Wash & Press',
            status: OrderStatus.inProgress,
            items: [
              const LaundryItemEntity(
                id: 't1',
                name: 'T-Shirts',
                icon: Icons.content_cut,
                quantity: 3,
                selectedService: LaundryServiceType.wash,
              ),
              const LaundryItemEntity(
                id: 'c1',
                name: 'Coats',
                icon: Icons.accessibility_new,
                quantity: 2,
                selectedService: LaundryServiceType.press,
              ),
            ],
          ),
          LaundryOrderEntity(
            id: 'd2',
            orderId: '#ORD20240610222',
            date: DateTime.now().subtract(const Duration(days: 3)),
            totalItems: 3,
            serviceType: 'Wash',
            status: OrderStatus.completed,
            items: [
              const LaundryItemEntity(
                id: 't1',
                name: 'T-Shirts',
                icon: Icons.content_cut,
                quantity: 3,
                selectedService: LaundryServiceType.wash,
              ),
            ],
          ),
          LaundryOrderEntity(
            id: 'd3',
            orderId: '#ORD20240605333',
            date: DateTime.now().subtract(const Duration(days: 8)),
            totalItems: 2,
            serviceType: 'Press',
            status: OrderStatus.readyForPickup,
            items: [
              const LaundryItemEntity(
                id: 'c1',
                name: 'Coats',
                icon: Icons.accessibility_new,
                quantity: 2,
                selectedService: LaundryServiceType.press,
              ),
            ],
          ),
        ];
      }

      _orders.assignAll(ordersList);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _updateStatusUseCase.execute(orderId, status);
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: status);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update status: $e');
    }
  }

  Future<void> fetchLaundryCost() async {
    try {
      final cost = await _costUseCase.getCost();
      washPrice.value = cost.washPrice;
      pressPrice.value = cost.pressPrice;
      bothPrice.value = cost.bothPrice;
    } catch (e) {
      print('Error fetching laundry cost: $e');
    }
  }

  Future<void> updateLaundryCost(
      {double? wash, double? press, double? both}) async {
    try {
      final currentCost = LaundryCostEntity(
        washPrice: wash ?? washPrice.value,
        pressPrice: press ?? pressPrice.value,
        bothPrice: both ?? bothPrice.value,
      );
      await _costUseCase.updateCost(currentCost);
      if (wash != null) washPrice.value = wash;
      if (press != null) pressPrice.value = press;
      if (both != null) bothPrice.value = both;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update costs: $e');
    }
  }

  void updateItem(LaundryItemEntity updatedItem) {
    final index =
        selectableItems.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      selectableItems[index] = updatedItem;
    }
  }

  void resetItems() {
    for (var i = 0; i < selectableItems.length; i++) {
      selectableItems[i] = selectableItems[i].copyWith(
        quantity: 0,
        selectedService: LaundryServiceType.wash,
      );
    }
  }

  void addOrder(LaundryOrderEntity order) {
    _orders.insert(0, order);
  }

  void setFilter(String newFilter) {
    filter.value = newFilter;
  }

  Future<void> submitOrder() async {
    final selected = selectableItems.where((i) => i.quantity > 0).toList();
    if (selected.isEmpty) {
      Get.snackbar('Error', 'Please select at least one item');
      return;
    }

    isLoading.value = true;
    try {
      final order = LaundryOrderEntity(
        id: '', // Backend generates id
        orderId: '', // Backend generates orderId
        date: DateTime.now(),
        totalItems: selected.fold(0, (sum, i) => sum + i.quantity),
        serviceType: selected.length == 1
            ? selected.first.selectedService.label
            : 'Mixed Service',
        status: OrderStatus.requested,
        items: selected,
      );

      await _createOrderUseCase.execute(order);
      resetItems();
      await fetchOrders(); // Refresh order history
      Get.back();
      Get.snackbar('Success', 'Laundry order placed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitOrderFromItems(LaundryOrderEntity order) async {
    isLoading.value = true;
    try {
      await _createOrderUseCase.execute(order);
      resetItems();
      await fetchOrders(); // Refresh order history
      Get.back();
      Get.snackbar('Success', 'Laundry order placed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to place order: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }
}
