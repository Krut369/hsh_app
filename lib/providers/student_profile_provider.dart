import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/models/student_profile.dart';

final studentProfileProvider = StateProvider<StudentProfile>(
  (ref) => StudentProfile(
    name: 'Parth Prajapati',
    college: 'V.P. & R.P.T.P. Science College',
    room: '3000',
    id: '367',
    imagePath: 'assets/profile_screen.jpg',
  ),
);
