// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'laundry_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaundryItemModel _$LaundryItemModelFromJson(Map<String, dynamic> json) =>
    LaundryItemModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      iconCodePoint: (json['iconCodePoint'] as num?)?.toInt(),
      iconFontFamily: json['iconFontFamily'] as String?,
      iconFontPackage: json['iconFontPackage'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      selectedService: json['selectedService'] as String,
    );

Map<String, dynamic> _$LaundryItemModelToJson(LaundryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'iconCodePoint': instance.iconCodePoint,
      'iconFontFamily': instance.iconFontFamily,
      'iconFontPackage': instance.iconFontPackage,
      'quantity': instance.quantity,
      'selectedService': instance.selectedService,
    };

LaundryOrderModel _$LaundryOrderModelFromJson(Map<String, dynamic> json) =>
    LaundryOrderModel(
      id: json['id'] as String?,
      orderId: json['orderId'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      totalItems: (json['totalItems'] as num).toInt(),
      serviceType: json['serviceType'] as String,
      status: json['status'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => LaundryItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$LaundryOrderModelToJson(LaundryOrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'date': instance.date?.toIso8601String(),
      'totalItems': instance.totalItems,
      'serviceType': instance.serviceType,
      'status': instance.status,
      'items': instance.items,
      'note': instance.note,
    };

LaundryCostModel _$LaundryCostModelFromJson(Map<String, dynamic> json) =>
    LaundryCostModel(
      washPrice: (json['washPrice'] as num).toDouble(),
      pressPrice: (json['pressPrice'] as num).toDouble(),
      bothPrice: (json['bothPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$LaundryCostModelToJson(LaundryCostModel instance) =>
    <String, dynamic>{
      'washPrice': instance.washPrice,
      'pressPrice': instance.pressPrice,
      'bothPrice': instance.bothPrice,
    };
