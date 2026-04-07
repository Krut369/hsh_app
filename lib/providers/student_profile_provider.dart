import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/models/student_profile_model.dart';

final studentProfileProvider = StateProvider<StudentProfile>(
  (ref) => StudentProfile(
    name: 'Krutarth Solanki',
    college: 'DAIICT',
    room: '304',
    id: '202350010',
    group: 'Pavitra',
    imagePath: 'assets/profile_screen.jpg',
  ),
);
