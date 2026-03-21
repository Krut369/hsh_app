// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      username: json['username'] as String,
      name: json['name'] as String,
      role: $enumDecode(_$UserRoleEnumMap, json['role']),
      roomNumber: json['room_number'] as String?,
      hostelBlock: json['hostel_block'] as String?,
      phone: json['phone'] as String?,
      profileImage: json['profile_image'] as String?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$AuthUserModelToJson(AuthUserModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'name': instance.name,
      'role': _$UserRoleEnumMap[instance.role]!,
      'room_number': instance.roomNumber,
      'hostel_block': instance.hostelBlock,
      'phone': instance.phone,
      'profile_image': instance.profileImage,
      'token': instance.token,
    };

const _$UserRoleEnumMap = {
  UserRole.student: 'student',
  UserRole.laundry: 'laundry',
  UserRole.complain: 'complain',
  UserRole.leader: 'leader',
};
