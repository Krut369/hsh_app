import 'package:json_annotation/json_annotation.dart';
import '../../../../core/enums/user_role.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  @JsonKey(name: 'username')
  final String username;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'role')
  final UserRole role;

  @JsonKey(name: 'room_number')
  final String? roomNumber;

  @JsonKey(name: 'hostel_block')
  final String? hostelBlock;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'profile_image')
  final String? profileImage;

  @JsonKey(name: 'token')
  final String? token;

  AuthUserModel({
    required this.username,
    required this.name,
    required this.role,
    this.roomNumber,
    this.hostelBlock,
    this.phone,
    this.profileImage,
    this.token,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);

  UserEntity toEntity() => UserEntity(
        username: username,
        name: name,
        role: role,
        roomNumber: roomNumber,
        hostelBlock: hostelBlock,
        phone: phone,
        profileImage: profileImage,
        token: token,
      );
}
