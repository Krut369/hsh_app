// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthUserModel _$AuthUserModelFromJson(Map<String, dynamic> json) =>
    AuthUserModel(
      username: json['username'] as String?,
      name: json['name'] as String?,
      role: json['role'] == null
          ? UserRole.student
          : UserRole.parse(json['role'] as String?),
      roomNumber: json['room_number'] as String?,
      email: json['email'] as String?,
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
      'email': instance.email,
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
