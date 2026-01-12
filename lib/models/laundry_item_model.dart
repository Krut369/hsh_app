// lib/models/laundry_item_model.dart

import 'package:flutter/material.dart';

/// Represents the type of laundry service selected for an item.
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

  Color get backgroundColor {
    switch (this) {
      case LaundryServiceType.wash:
        return Colors.blue.shade100;
      case LaundryServiceType.press:
        return Colors.purple.shade100;
      case LaundryServiceType.both:
        return Colors.green.shade100;
    }
  }

  Color get textColor {
    switch (this) {
      case LaundryServiceType.wash:
        return Colors.blue.shade800;
      case LaundryServiceType.press:
        return Colors.purple.shade800;
      case LaundryServiceType.both:
        return Colors.green.shade800;
    }
  }
}

/// A model representing a single laundry item (e.g., Shirt, Pants)
/// used in the laundry order selection process.
@immutable
class LaundryItem {
  final String id;
  final String name;
  final IconData icon;
  final int quantity;
  final LaundryServiceType selectedService;

  const LaundryItem({
    required this.id,
    required this.name,
    required this.icon,
    this.quantity = 0,
    this.selectedService = LaundryServiceType.wash,
  });

  /// Returns a new copy of this item with optional overrides.
  LaundryItem copyWith({
    String? id,
    String? name,
    IconData? icon,
    int? quantity,
    LaundryServiceType? selectedService,
  }) {
    return LaundryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      quantity: quantity ?? this.quantity,
      selectedService: selectedService ?? this.selectedService,
    );
  }

  /// Converts the enum [LaundryServiceType] to a user-friendly string.
  String serviceTypeToString(LaundryServiceType type) {
    switch (type) {
      case LaundryServiceType.wash:
        return 'Wash';
      case LaundryServiceType.press:
        return 'Press';
      case LaundryServiceType.both:
        return 'Both';
    }
  }

  /// Converts the LaundryItem to a map for storage or serialization.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'iconFontPackage': icon.fontPackage,
      'quantity': quantity,
      'selectedService': selectedService.name,
    };
  }

  /// Reconstructs a LaundryItem from a map.
  factory LaundryItem.fromMap(Map<String, dynamic> map) {
    return LaundryItem(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: IconData(
        map['iconCodePoint'] as int,
        fontFamily: map['iconFontFamily'] as String?,
        fontPackage: map['iconFontPackage'] as String?,
      ),
      quantity: map['quantity'] as int,
      selectedService: LaundryServiceType.values.firstWhere(
        (e) => e.name == map['selectedService'],
        orElse: () => LaundryServiceType.wash,
      ),
    );
  }

  @override
  String toString() {
    return 'LaundryItem(id: $id, name: $name, quantity: $quantity, selectedService: $selectedService)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LaundryItem &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.quantity == quantity &&
        other.selectedService == selectedService;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        quantity.hashCode ^
        selectedService.hashCode;
  }
}
