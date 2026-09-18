import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../../core/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_user_model.g.dart';

/// Matches the V2.0.0 API user schema:
///   { status, token, data: { user: { id, name, email, role, groupName, isTemporary, expiry } } }
/// Token is at the TOP LEVEL of the response (not inside data).
@JsonSerializable()
class AuthUserModel {
  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(
      name: 'role', fromJson: UserRole.parse, defaultValue: UserRole.student)
  final UserRole role;

  @JsonKey(name: 'groupName')
  final String? groupName;

  @JsonKey(name: 'isTemporary')
  final bool isTemporary;

  /// JWT access token — lives at TOP LEVEL of login response.
  @JsonKey(name: 'token')
  final String? token;

  AuthUserModel({
    this.id,
    this.name,
    this.email,
    required this.role,
    this.groupName,
    this.isTemporary = false,
    this.token,
  });

  /// V2.0.0 login response shape:
  ///   { status: "success", token: "<jwt>", data: { user: { id, name, email, role, ... } } }
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    debugPrint('AuthUserModel.fromJson received: $json');

    final target = Map<String, dynamic>.from(json);

    // Extract token from top level or data level
    final topLevelToken = json['token'];

    // Flatten data.user into target
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      final user = data['user'];
      if (user is Map<String, dynamic>) {
        target.addAll(Map<String, dynamic>.from(user));
      } else {
        target.addAll(Map<String, dynamic>.from(data));
      }
    }

    // Also check for direct user key
    final directUser = json['user'];
    if (directUser is Map<String, dynamic>) {
      target.addAll(Map<String, dynamic>.from(directUser));
    }

    // Always preserve top-level token
    if (topLevelToken != null) {
      target['token'] = topLevelToken;
    }

    return _$AuthUserModelFromJson(target);
  }

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        id: id,
        username: email ?? '',
        name: name ?? email ?? 'User',
        role: role,
        token: token,
      );
}
