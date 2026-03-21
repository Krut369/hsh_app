import "package:hsh_app/core/enums/user_role.dart";

class UserEntity {
  final String username;
  final String name;
  final UserRole role;
  final String? roomNumber;
  final String? hostelBlock;
  final String? phone;
  final String? profileImage;
  final String? token;

  UserEntity({
    required this.username,
    required this.name,
    required this.role,
    this.roomNumber,
    this.hostelBlock,
    this.phone,
    this.profileImage,
    this.token,
  });
}
