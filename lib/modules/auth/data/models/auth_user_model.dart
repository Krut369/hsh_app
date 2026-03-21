import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  @JsonKey(name: 'username')
  final String? username;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(
      name: 'role', fromJson: UserRole.parse, defaultValue: UserRole.student)
  final UserRole role;

  @JsonKey(name: 'room_number')
  final String? roomNumber;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'hostel_block')
  final String? hostelBlock;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @JsonKey(name: 'token')
  final String? token;

  AuthUserModel({
    this.username,
    this.name,
    required this.role,
    this.roomNumber,
    this.email,
    this.hostelBlock,
    this.phone,
    this.profileImage,
    this.token,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('AuthUserModel.fromJson received: $json');
    // Start with all top-level keys
    final target = Map<String, dynamic>.from(json);

    // Check for "data" and then "user" recursively (backend returns data -> user)
    // We want to pull all fields from both to the top level for mapping
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      target.addAll(Map<String, dynamic>.from(data));
      final user = data['user'];
      if (user is Map<String, dynamic>) {
        target.addAll(Map<String, dynamic>.from(user));
      }
    }

    // Also check for direct "user" if present
    final directUser = json['user'];
    if (directUser is Map<String, dynamic>) {
      target.addAll(Map<String, dynamic>.from(directUser));
    }

    // Capture token from any possible level
    target['token'] ??=
        json['token'] ?? json['data']?['token'] ?? json['user']?['token'];

    return _$AuthUserModelFromJson(target);
  }

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        username: username ?? email ?? '',
        name: name ?? username ?? 'User',
        role: role,
        roomNumber: roomNumber,
        hostelBlock: hostelBlock,
        phone: phone,
        profileImage: profileImage,
        token: token,
      );
}
