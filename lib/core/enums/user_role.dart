import 'package:flutter/foundation.dart';

enum UserRole {
  student,
  laundry,
  complain,
  leader;

  static UserRole parse(dynamic role) {
    final roleStr = role?.toString();
    debugPrint('Parsing UserRole from: $roleStr');
    if (roleStr == null) return UserRole.student;

    final normalized = roleStr.toLowerCase();
    if (normalized.contains('student')) return UserRole.student;
    if (normalized.contains('laundry')) return UserRole.laundry;
    if (normalized.contains('complain')) return UserRole.complain;
    if (normalized.contains('leader')) return UserRole.leader;

    debugPrint('Unknown role string: $roleStr, defaulting to student');
    return UserRole.student;
  }

  String get toBackendString {
    switch (this) {
      case UserRole.student:
        return 'student';
      case UserRole.laundry:
        return 'laundry';
      case UserRole.complain:
        return 'complain';
      case UserRole.leader:
        return 'leader';
    }
  }
}
