import 'package:hsh_app/core/enums/user_role.dart';

/// Domain entity for authenticated user.
/// Matches V2.0.0 API user schema.
class UserEntity {
  final int? id;
  final String username; // email used as username
  final String name;
  final UserRole role;
  final String? token;

  // Student-specific — resolved separately via GET /students/:aadhar
  final String? aadhar; // cached after bootstrap call to /fees/summary

  UserEntity({
    this.id,
    required this.username,
    required this.name,
    required this.role,
    this.token,
    this.aadhar,
  });

  UserEntity copyWith({
    int? id,
    String? username,
    String? name,
    UserRole? role,
    String? token,
    String? aadhar,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      role: role ?? this.role,
      token: token ?? this.token,
      aadhar: aadhar ?? this.aadhar,
    );
  }
}
