enum UserRole { student, laundry, complain }

class Student {
  final String username;
  final String password;
  final String name;
  final UserRole role;

  Student({
    required this.username,
    required this.password,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toMap() => {
    'username': username,
    'password': password,
    'name': name,
    'role': role.name,
  };

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    username: map['username'],
    password: map['password'],
    name: map['name'],
    role: UserRole.values
        .firstWhere((e) => e.name == map['role'], orElse: () => UserRole.student),
  );
}
