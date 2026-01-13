class AttendanceRecord {
  final String id;
  final String studentId;
  final String studentName;
  final String room;
  final String eventType; // lunch, dinner, sabha, study_hour
  final DateTime timestamp;
  final bool isPresent;

  AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.room,
    required this.eventType,
    required this.timestamp,
    required this.isPresent,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'studentName': studentName,
        'room': room,
        'eventType': eventType,
        'timestamp': timestamp.toIso8601String(),
        'isPresent': isPresent,
      };

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) => AttendanceRecord(
        id: map['id'],
        studentId: map['studentId'],
        studentName: map['studentName'],
        room: map['room'],
        eventType: map['eventType'],
        timestamp: DateTime.parse(map['timestamp']),
        isPresent: map['isPresent'],
      );
}
