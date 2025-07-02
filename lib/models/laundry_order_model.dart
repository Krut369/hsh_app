// lib/models/laundry_order_model.dart
import 'package:flutter/foundation.dart';
import 'laundry_item_model.dart'; // Import the LaundryItem model

/// Enum representing the status of a laundry order.
enum OrderStatus {
  inProgress,
  completed,
  cancelled,
}

/// Model representing a laundry order, including its metadata and items.
@immutable
class LaundryOrder {
  final String id;               // Unique identifier (UUID)
  final String orderId;         // Displayed Order ID (e.g., #ORD20250704)
  final DateTime date;          // Date of the order
  final int totalItems;         // Total number of items
  final String serviceType;     // Combined service type string
  final OrderStatus status;     // Current status of the order
  final List<LaundryItem> items; // List of laundry items in this order

  const LaundryOrder({
    required this.id,
    required this.orderId,
    required this.date,
    required this.totalItems,
    required this.serviceType,
    required this.status,
    this.items = const [],
  });

  /// Creates a copy of the current object with optional updated values.
  LaundryOrder copyWith({
    String? id,
    String? orderId,
    DateTime? date,
    int? totalItems,
    String? serviceType,
    OrderStatus? status,
    List<LaundryItem>? items,
  }) {
    return LaundryOrder(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      date: date ?? this.date,
      totalItems: totalItems ?? this.totalItems,
      serviceType: serviceType ?? this.serviceType,
      status: status ?? this.status,
      items: items ?? this.items,
    );
  }

  /// Serializes the order to a Map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'date': date.toIso8601String(),
      'totalItems': totalItems,
      'serviceType': serviceType,
      'status': status.name,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }

  /// Deserializes a LaundryOrder from a Map.
  factory LaundryOrder.fromMap(Map<String, dynamic> map) {
    return LaundryOrder(
      id: map['id'] as String,
      orderId: map['orderId'] as String,
      date: DateTime.parse(map['date'] as String),
      totalItems: map['totalItems'] as int,
      serviceType: map['serviceType'] as String,
      status: OrderStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => OrderStatus.inProgress,
      ),
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => LaundryItem.fromMap(item as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  @override
  String toString() {
    return 'LaundryOrder('
        'id: $id, orderId: $orderId, date: $date, '
        'totalItems: $totalItems, serviceType: $serviceType, '
        'status: $status, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaundryOrder &&
        other.id == id &&
        other.orderId == orderId &&
        other.date == date &&
        other.totalItems == totalItems &&
        other.serviceType == serviceType &&
        other.status == status &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
    orderId.hashCode ^
    date.hashCode ^
    totalItems.hashCode ^
    serviceType.hashCode ^
    status.hashCode ^
    items.hashCode;
  }
}
