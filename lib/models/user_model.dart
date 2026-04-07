import "package:hsh_app/core/enums/user_role.dart";

class Student {
  final String username;
  final String password;
  final String name;
  final UserRole role;
  final String? roomNumber;
  final String? hostelBlock;
  final String? phone;
  final String? profileImage;

  Student({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
    this.roomNumber,
    this.hostelBlock,
    this.phone,
    this.profileImage,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'name': name,
        'role': role.name,
        if (roomNumber != null) 'room_number': roomNumber,
        if (hostelBlock != null) 'hostel_block': hostelBlock,
        if (phone != null) 'phone': phone,
        if (profileImage != null) 'profile_image': profileImage,
      };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
        username: map['username'] ?? '',
        password: map['password'] ?? '',
        name: map['name'] ?? '',
        role: _parseRole(map['role']),
        roomNumber: map['room_number'],
        hostelBlock: map['hostel_block'],
        phone: map['phone'],
        profileImage: map['profile_image'],
      );

  /// Create a copy with updated fields
  Student copyWith({
    String? username,
    String? password,
    String? name,
    UserRole? role,
    String? roomNumber,
    String? hostelBlock,
    String? phone,
    String? profileImage,
  }) {
    return Student(
      username: username ?? this.username,
      password: password ?? this.password,
      name: name ?? this.name,
      role: role ?? this.role,
      roomNumber: roomNumber ?? this.roomNumber,
      hostelBlock: hostelBlock ?? this.hostelBlock,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  static UserRole _parseRole(String? role) {
    if (role == null) return UserRole.student;
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'laundry':
        return UserRole.laundry;
      case 'complain':
      case 'complaint': // Common misspelling/variant
        return UserRole.complain;
      case 'leader':
        return UserRole.leader;
      default:
        return UserRole.student;
    }
  }
}
