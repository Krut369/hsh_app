import 'package:flutter/material.dart';


enum HolidayStatus {
  pending,
  confirmed,
  rejected;

  String get label {
    switch (this) {
      case HolidayStatus.pending:
        return 'Pending';
      case HolidayStatus.confirmed:
        return 'Confirmed';
      case HolidayStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case HolidayStatus.pending:
        return Colors.orange;
      case HolidayStatus.confirmed:
        return Colors.green; // Changed to green for better visibility
      case HolidayStatus.rejected:
        return Colors.redAccent;
    }
  }
}

@immutable
@immutable
class Holiday {
  final String id;
  final String name;
  final DateTime startDate;
  final DateTime endDate;
  final HolidayStatus status;
  final String? reason; // NEW FIELD

  const Holiday({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    this.status = HolidayStatus.pending,
    this.reason,
  });

  Holiday copyWith({
    String? id,
    String? name,
    DateTime? startDate,
    DateTime? endDate,
    HolidayStatus? status,
    String? reason,
  }) {
    return Holiday(
      id: id ?? this.id,
      name: name ?? this.name,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.name,
      'reason': reason,
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
      reason: map['reason'] as String?,
    );
  }

  @override
  String toString() {
    return 'Holiday(id: $id, name: $name, startDate: $startDate, endDate: $endDate, status: $status, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Holiday &&
        other.id == id &&
        other.name == name &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.status == status &&
        other.reason == reason;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    startDate.hashCode ^
    endDate.hashCode ^
    status.hashCode ^
    reason.hashCode;
  }
}
