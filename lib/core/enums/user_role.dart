import "package:hsh_app/core/enums/user_role.dart";
enum UserRole {
  student,
  laundry,
  complain,
  leader;

  static UserRole parse(String? role) {
    if (role == null) return UserRole.student;
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'laundry':
        return UserRole.laundry;
      case 'complain':
      case 'complaint':
        return UserRole.complain;
      case 'leader':
        return UserRole.leader;
      default:
        return UserRole.student;
    }
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
