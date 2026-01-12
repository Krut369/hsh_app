// lib/providers/laundry_order_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/laundry_order_model.dart';
import '../models/laundry_item_model.dart'; // Import LaundryItem model

/// A StateNotifier that manages a list of LaundryOrder objects.
/// It provides methods to add, update, and remove laundry orders.
class LaundryOrderListNotifier extends StateNotifier<List<LaundryOrder>> {
  // Initial state with some dummy data to populate the list as per the image
  LaundryOrderListNotifier()
      : super([
    LaundryOrder(
      id: '1',
      orderId: '#ORD20250630',
      date: DateTime(2025, 6, 30),
      totalItems: 6,
      serviceType: 'Wash & Press',
      status: OrderStatus.inProgress,
      items: [
        LaundryItem(
            id: 'item1',
            name: 'Shirt',
            icon: Icons.checkroom,
            quantity: 3,
            selectedService: LaundryServiceType.wash),
        LaundryItem(
            id: 'item2',
            name: 'Pants',
            icon: Icons.person,
            quantity: 2,
            selectedService: LaundryServiceType.press),
        LaundryItem(
            id: 'item3',
            name: 'T-Shirt',
            icon: Icons.content_cut,
            quantity: 1,
            selectedService: LaundryServiceType.both),
      ],
    ),
    LaundryOrder(
      id: '2',
      orderId: '#ORD20250625',
      date: DateTime(2025, 6, 25),
      totalItems: 6,
      serviceType: 'Wash & Press',
      status: OrderStatus.completed,
      items: [
        LaundryItem(
            id: 'item4',
            name: 'Shirts',
            icon: Icons.checkroom,
            quantity: 2,
            selectedService: LaundryServiceType.wash),
        LaundryItem(
            id: 'item5',
            name: 'Jeans',
            icon: Icons.person,
            quantity: 4,
            selectedService: LaundryServiceType.press),
      ],
    ),
  ]);

  /// Adds a new laundry order to the list.
  void addOrder(LaundryOrder order) {
    state = [...state, order]; // Create a new list with the added order
  }

  /// Updates an existing laundry order in the list.
  /// It finds the order by its ID and replaces it with the updated version.
  void updateOrder(LaundryOrder updatedOrder) {
    state = [
      for (final order in state)
        if (order.id == updatedOrder.id) updatedOrder else order,
    ];
  }

  /// Removes a laundry order from the list based on its ID.
  void removeOrder(String orderId) {
    state = state.where((order) => order.id != orderId).toList();
  }
}

/// The Riverpod provider for the LaundryOrderListNotifier.
/// This allows widgets to access and interact with the list of laundry orders.
final laundryOrderListProvider =
StateNotifierProvider<LaundryOrderListNotifier, List<LaundryOrder>>(
      (ref) => LaundryOrderListNotifier(),
);

/// A StateNotifier that manages the list of selectable LaundryItem types.
/// This will be used in the item selection screen.
class SelectableLaundryItemsNotifier extends StateNotifier<List<LaundryItem>> {
  SelectableLaundryItemsNotifier()
      : super([
    // Initial list of available laundry items
    const LaundryItem(id: 's1', name: 'Shirts', icon: Icons.checkroom),
    const LaundryItem(id: 'p1', name: 'Pants', icon: Icons.person),
    const LaundryItem(id: 'j1', name: 'Jackets', icon: Icons.work),
    const LaundryItem(id: 't1', name: 'T-Shirts', icon: Icons.content_cut),
    const LaundryItem(id: 'c1', name: 'Coats', icon: Icons.accessibility_new),
    const LaundryItem(id: 'o1', name: 'Others', icon: Icons.devices_other),
  ]);

  /// Updates a specific laundry item in the selectable list.
  /// This is used to change quantity or service type on the selection screen.
  void updateItem(LaundryItem updatedItem) {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
  }

  /// Resets the quantities and selected services of all items.
  void resetItems() {
    state = [
      for (final item in state)
        item.copyWith(quantity: 0, selectedService: LaundryServiceType.wash),
    ];
  }
}

/// The Riverpod provider for the SelectableLaundryItemsNotifier.
final selectableLaundryItemsProvider =
StateNotifierProvider<SelectableLaundryItemsNotifier, List<LaundryItem>>(
      (ref) => SelectableLaundryItemsNotifier(),
);
