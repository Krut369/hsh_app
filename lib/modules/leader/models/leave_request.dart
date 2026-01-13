enum LeaveStatus { pending, approved, rejected }

class LeaveRequest {
  final String id;
  final String studentId;
  final String studentName;
  final String studentAvatar;
  final String room;
  final String leaveType; // Home Visit, Medical, Family Emergency
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final LeaveStatus status;
  final DateTime appliedAt;
  final DateTime? processedAt;

  LeaveRequest({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentAvatar,
    required this.room,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.appliedAt,
    this.processedAt,
  });

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentId': studentId,
        'studentName': studentName,
        'studentAvatar': studentAvatar,
        'room': room,
        'leaveType': leaveType,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'reason': reason,
        'status': status.name,
        'appliedAt': appliedAt.toIso8601String(),
        'processedAt': processedAt?.toIso8601String(),
      };

  factory LeaveRequest.fromMap(Map<String, dynamic> map) => LeaveRequest(
        id: map['id'],
        studentId: map['studentId'],
        studentName: map['studentName'],
        studentAvatar: map['studentAvatar'],
        room: map['room'],
        leaveType: map['leaveType'],
        startDate: DateTime.parse(map['startDate']),
        endDate: DateTime.parse(map['endDate']),
        reason: map['reason'],
        status: LeaveStatus.values.firstWhere((e) => e.name == map['status']),
        appliedAt: DateTime.parse(map['appliedAt']),
        processedAt: map['processedAt'] != null ? DateTime.parse(map['processedAt']) : null,
      );

  LeaveRequest copyWith({
    LeaveStatus? status,
    DateTime? processedAt,
  }) {
    return LeaveRequest(
      id: id,
      studentId: studentId,
      studentName: studentName,
      studentAvatar: studentAvatar,
      room: room,
      leaveType: leaveType,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
      status: status ?? this.status,
      appliedAt: appliedAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }
}
