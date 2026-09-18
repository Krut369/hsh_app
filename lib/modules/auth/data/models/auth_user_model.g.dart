// GENERATED CODE - DO NOT MODIFY BY HAND
// (Manually updated to match V2.0.0 auth response schema)

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      role: json['role'] == null
          ? UserRole.student
          : UserRole.parse(json['role']),
      groupName: json['groupName'] as String?,
      isTemporary: json['isTemporary'] as bool? ?? false,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'role': _$UserRoleEnumMap[instance.role]!,
      'groupName': instance.groupName,
      'isTemporary': instance.isTemporary,
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.laundry: 'laundry',
  UserRole.complain: 'complain',
  UserRole.leader: 'leader',
};
