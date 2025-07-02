import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../models/student_profile.dart';
final studentProfileProvider = StateProvider<StudentProfile>(
      (ref) => StudentProfile(
    name: 'Parth Prajapati',
    college: 'V.P. & R.P.T.P. Science College',
    room: '3000',
    id: '367',
    imagePath: 'assets/profile_screen.jpg',
  ),
);