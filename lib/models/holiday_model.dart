import 'package:flutter/foundation.dart';

enum HolidayStatus { pending, confirmed, rejected }

@immutable
class Holiday {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final HolidayStatus status; // NEW FIELD

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.status = HolidayStatus.pending, // default is pending
  });

  Holiday copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    HolidayStatus? status,
  }) {
    return Holiday(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name, // saved as string
    };
  }

  factory Holiday.fromMap(Map<String, dynamic> map) {
    return Holiday(
      id: map['id'] as String,
      name: map['name'] as String,
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      status: HolidayStatus.values.firstWhere(
            (e) => e.name == map['status'],
        orElse: () => HolidayStatus.pending,
      ),
    );
  }

  @override
  String toString() {
    return 'Holiday(id: $id, name: $name, startDate: $startDate, endDate: $endDate, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Holiday &&
        other.id == id &&
        other.name == name &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    startDate.hashCode ^
    endDate.hashCode ^
    status.hashCode;
  }
}
