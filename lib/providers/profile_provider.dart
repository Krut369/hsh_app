import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/profile_model.dart';

final profileProvider = Provider<ProfileData>((ref) {
  return const ProfileData(
    userName: 'Teacher Demo',
    profileImageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    details: <ProfileDetail>[
      ProfileDetail(icon: Icons.wc_outlined, label: 'ID', value: '367'),
      ProfileDetail(icon: Icons.person_outline, label: 'Name', value: 'Parth Prajapati'),
      ProfileDetail(icon: Icons.phone, label: 'Room', value: '3000'),
      ProfileDetail(icon: Icons.calendar_today_outlined, label: 'College / School', value: 'V P and RPTP Science College'),
      ProfileDetail(icon: Icons.monetization_on, label: 'Laundry Balance', value: '12'),
    ],
  );
});
