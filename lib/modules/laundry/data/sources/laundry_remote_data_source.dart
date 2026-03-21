import 'package:hsh_app/modules/laundry/data/models/laundry_models.dart';
import 'package:flutter/material.dart';

class LaundryRemoteDataSource {
  Future<List<LaundryOrderModel>> getOrders() async {
    // Mocking API call
    await Future.delayed(const Duration(seconds: 1));
    return [
      LaundryOrderModel(
        id: '1',
        orderId: 'ORD-001',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        totalItems: 5,
        serviceType: 'Wash',
        status: 'requested',
        items: [
          LaundryItemModel(
              id: '1',
              name: 'T-Shirt',
              quantity: 3,
              iconCodePoint: Icons.tsunami.codePoint,
              selectedService: 'wash'),
          LaundryItemModel(
              id: '2',
              name: 'Jeans',
              quantity: 2,
              iconCodePoint: Icons.tsunami.codePoint,
              selectedService: 'wash'),
        ],
      ),
      LaundryOrderModel(
        id: '2',
        orderId: 'ORD-002',
        date: DateTime.now().subtract(const Duration(days: 1)),
        totalItems: 3,
        serviceType: 'Press',
        status: 'inProgress',
        items: [
          LaundryItemModel(
              id: '3',
              name: 'Shirt',
              quantity: 3,
              iconCodePoint: Icons.iron.codePoint,
              selectedService: 'press'),
        ],
      ),
    ];
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<LaundryCostModel> getLaundryCost() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return LaundryCostModel(washPrice: 10, pressPrice: 5, bothPrice: 15);
  }

  Future<void> updateLaundryCost(LaundryCostModel cost) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
