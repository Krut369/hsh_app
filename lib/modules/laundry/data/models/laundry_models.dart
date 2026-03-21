import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

part 'laundry_models.g.dart';

@JsonSerializable()
class LaundryItemModel {
  final String id;
  final String name;
  final int iconCodePoint;
  final String? iconFontFamily;
  final String? iconFontPackage;
  final int quantity;
  final String selectedService;

  LaundryItemModel({
    required this.id,
    required this.name,
    required this.iconCodePoint,
    this.iconFontFamily,
    this.iconFontPackage,
    required this.quantity,
    required this.selectedService,
  });

  factory LaundryItemModel.fromJson(Map<String, dynamic> json) =>
      _$LaundryItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryItemModelToJson(this);

  LaundryItemEntity toEntity() => LaundryItemEntity(
        id: id,
        name: name,
        icon: IconData(iconCodePoint,
            fontFamily: iconFontFamily, fontPackage: iconFontPackage),
        quantity: quantity,
        selectedService: LaundryServiceType.values.firstWhere(
            (e) => e.name == selectedService,
            orElse: () => LaundryServiceType.wash),
      );

  factory LaundryItemModel.fromEntity(LaundryItemEntity entity) =>
      LaundryItemModel(
        id: entity.id,
        name: entity.name,
        iconCodePoint: entity.icon.codePoint,
        iconFontFamily: entity.icon.fontFamily,
        iconFontPackage: entity.icon.fontPackage,
        quantity: entity.quantity,
        selectedService: entity.selectedService.name,
      );
}

@JsonSerializable()
class LaundryOrderModel {
  final String id;
  final String orderId;
  final DateTime date;
  final int totalItems;
  final String serviceType;
  final String status;
  final List<LaundryItemModel> items;
  final String? note;

  LaundryOrderModel({
    required this.id,
    required this.orderId,
    required this.date,
    required this.totalItems,
    required this.serviceType,
    required this.status,
    required this.items,
    this.note,
  });

  factory LaundryOrderModel.fromJson(Map<String, dynamic> json) =>
      _$LaundryOrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryOrderModelToJson(this);

  LaundryOrderEntity toEntity() => LaundryOrderEntity(
        id: id,
        orderId: orderId,
        date: date,
        totalItems: totalItems,
        serviceType: serviceType,
        status: OrderStatus.values.firstWhere((e) => e.name == status,
            orElse: () => OrderStatus.requested),
        items: items.map((i) => i.toEntity()).toList(),
        note: note,
      );

  factory LaundryOrderModel.fromEntity(LaundryOrderEntity entity) =>
      LaundryOrderModel(
        id: entity.id,
        orderId: entity.orderId,
        date: entity.date,
        totalItems: entity.totalItems,
        serviceType: entity.serviceType,
        status: entity.status.name,
        items: entity.items.map((i) => LaundryItemModel.fromEntity(i)).toList(),
        note: entity.note,
      );
}

@JsonSerializable()
class LaundryCostModel {
  final double washPrice;
  final double pressPrice;
  final double bothPrice;

  LaundryCostModel({
    required this.washPrice,
    required this.pressPrice,
    required this.bothPrice,
  });

  factory LaundryCostModel.fromJson(Map<String, dynamic> json) =>
      _$LaundryCostModelFromJson(json);
  Map<String, dynamic> toJson() => _$LaundryCostModelToJson(this);

  LaundryCostEntity toEntity() => LaundryCostEntity(
        washPrice: washPrice,
        pressPrice: pressPrice,
        bothPrice: bothPrice,
      );

  factory LaundryCostModel.fromEntity(LaundryCostEntity entity) =>
      LaundryCostModel(
        washPrice: entity.washPrice,
        pressPrice: entity.pressPrice,
        bothPrice: entity.bothPrice,
      );
}
