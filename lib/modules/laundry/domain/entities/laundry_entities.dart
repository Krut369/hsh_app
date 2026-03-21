import 'package:flutter/material.dart';

enum LaundryServiceType {
  wash,
  press,
  both;

  String get label {
    switch (this) {
      case LaundryServiceType.wash:
        return 'Wash';
      case LaundryServiceType.press:
        return 'Press';
      case LaundryServiceType.both:
        return 'Both';
    }
  }
}

enum OrderStatus {
  requested,
  inProgress,
  readyForPickup,
  completed,
  cancelled;

  String get label {
    switch (this) {
      case OrderStatus.requested:
        return 'Requested';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get backgroundColor {
    switch (this) {
      case OrderStatus.requested:
        return Colors.grey.shade200;
      case OrderStatus.inProgress:
        return Colors.amber.shade100;
      case OrderStatus.readyForPickup:
        return Colors.orange.shade100;
      case OrderStatus.completed:
        return Colors.green.shade100;
      case OrderStatus.cancelled:
        return Colors.red.shade100;
    }
  }

  Color get textColor {
    switch (this) {
      case OrderStatus.requested:
        return Colors.grey.shade800;
      case OrderStatus.inProgress:
        return Colors.amber.shade800;
      case OrderStatus.readyForPickup:
        return Colors.orange.shade800;
      case OrderStatus.completed:
        return Colors.green.shade800;
      case OrderStatus.cancelled:
        return Colors.red.shade800;
    }
  }
}

class LaundryItemEntity {
  final String id;
  final String name;
  final IconData icon;
  final int quantity;
  final LaundryServiceType selectedService;

  const LaundryItemEntity({
    required this.id,
    required this.name,
    required this.icon,
    this.quantity = 0,
    this.selectedService = LaundryServiceType.wash,
  });

  LaundryItemEntity copyWith({
    String? id,
    String? name,
    IconData? icon,
    int? quantity,
    LaundryServiceType? selectedService,
  }) {
    return LaundryItemEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
      selectedService: selectedService ?? this.selectedService,
    );
  }
}

class LaundryOrderEntity {
  final String id;
  final String orderId;
  final DateTime date;
  final int totalItems;
  final String serviceType;
  final OrderStatus status;
  final List<LaundryItemEntity> items;
  final String? note;

  const LaundryOrderEntity({
    required this.id,
    required this.orderId,
    required this.date,
    required this.totalItems,
    required this.serviceType,
    required this.status,
    this.items = const [],
    this.note,
  });

  LaundryOrderEntity copyWith({
    String? id,
    String? orderId,
    DateTime? date,
    int? totalItems,
    String? serviceType,
    OrderStatus? status,
    List<LaundryItemEntity>? items,
    String? note,
  }) {
    return LaundryOrderEntity(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      totalItems: totalItems ?? this.totalItems,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      items: items ?? this.items,
      note: note ?? this.note,
    );
  }
}

class LaundryCostEntity {
  final double washPrice;
  final double pressPrice;
  final double bothPrice;

  const LaundryCostEntity({
    required this.washPrice,
    required this.pressPrice,
    required this.bothPrice,
  });
}
