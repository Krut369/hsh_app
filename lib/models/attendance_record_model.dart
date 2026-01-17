import 'dart:convert';

enum AttendanceEventType {
  lunch,
  dinner,
  sabha,
  studyHour,
  arti,
  nightAttendance,
  other;

  String get displayName {
    switch (this) {
      case AttendanceEventType.lunch:
        return 'Lunch';
      case AttendanceEventType.dinner:
        return 'Dinner';
      case AttendanceEventType.sabha:
        return 'Sabha';
      case AttendanceEventType.studyHour:
        return 'Study Hour';
      case AttendanceEventType.arti:
        return 'Arti';
      case AttendanceEventType.nightAttendance:
        return 'Night Attendance';
      case AttendanceEventType.other:
        return 'Other';
    }
  }

  static AttendanceEventType fromString(String value) {
    final normalized = value.trim().toLowerCase().replaceAll(' ', '_');
    for (final type in values) {
      if (type.name.toLowerCase() == normalized) {
        return type;
      }
    }
    // Handle special cases or mismatches if necessary
    switch (normalized) {
      case 'study_hour':
      case 'studyhour':
        return AttendanceEventType.studyHour;
      case 'night_attendance':
      case 'nightattendance':
        return AttendanceEventType.nightAttendance;
      default:
        return AttendanceEventType.other;
    }
  }
}

class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String room;
  final AttendanceEventType eventType;
  final DateTime timestamp;
  final bool isPresent;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.room,
    required this.eventType,
    required this.timestamp,
    required this.isPresent,
  });

  AttendanceRecord copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? room,
    AttendanceEventType? eventType,
    DateTime? timestamp,
    bool? isPresent,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      room: room ?? this.room,
      eventType: eventType ?? this.eventType,
      timestamp: timestamp ?? this.timestamp,
      isPresent: isPresent ?? this.isPresent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'room': room,
      'eventType': eventType.name,
      'timestamp': timestamp.toIso8601String(),
      'isPresent': isPresent,
    };
  }

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id']?.toString() ?? '',
      studentId: map['studentId']?.toString() ?? '',
      studentName: map['studentName']?.toString() ?? '',
      room: map['room']?.toString() ?? '',
      eventType: map['eventType'] != null
          ? AttendanceEventType.fromString(map['eventType'].toString())
          : AttendanceEventType.other,
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
      isPresent: map['isPresent'] == true, // Handles null or false
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceRecord.fromJson(String source) =>
      AttendanceRecord.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AttendanceRecord(id: $id, studentId: $studentId, studentName: $studentName, room: $room, eventType: $eventType, timestamp: $timestamp, isPresent: $isPresent)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AttendanceRecord &&
        other.id == id &&
        other.studentId == studentId &&
        other.studentName == studentName &&
        other.room == room &&
        other.eventType == eventType &&
        other.timestamp == timestamp &&
        other.isPresent == isPresent;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        studentName.hashCode ^
        room.hashCode ^
        eventType.hashCode ^
        timestamp.hashCode ^
        isPresent.hashCode;
  }
}
