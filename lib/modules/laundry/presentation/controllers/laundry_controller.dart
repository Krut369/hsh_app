import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/get_laundry_orders_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/update_order_status_usecase.dart';
import 'package:hsh_app/modules/laundry/domain/usecases/manage_laundry_cost_usecase.dart';

class LaundryController extends GetxController {
  final GetLaundryOrdersUseCase _getOrdersUseCase;
  final UpdateOrderStatusUseCase _updateStatusUseCase;
  final ManageLaundryCostUseCase _costUseCase;

  LaundryController({
    required GetLaundryOrdersUseCase getOrdersUseCase,
    required UpdateOrderStatusUseCase updateStatusUseCase,
    required ManageLaundryCostUseCase costUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _updateStatusUseCase = updateStatusUseCase,
        _costUseCase = costUseCase;

  // Observables
  final _orders = <LaundryOrderEntity>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final filter = 'All'.obs;
  final tabIndex = 0.obs;

  // Selection logic for student module
  final selectableItems = <LaundryItemEntity>[
    const LaundryItemEntity(
        id: 't1', name: 'T-Shirts', icon: Icons.content_cut),
    const LaundryItemEntity(
        id: 'c1', name: 'Coats', icon: Icons.accessibility_new),
    const LaundryItemEntity(
        id: 'o1', name: 'Others', icon: Icons.devices_other),
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
      _orders.assignAll(fetchedOrders);
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

  void changeTab(int index) {
    tabIndex.value = index;
  }
}
