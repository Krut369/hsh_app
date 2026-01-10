import 'package:flutter/material.dart';

class ProfileDetail {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetail({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class ProfileData {
  final String userName;
  final String profileImageUrl;
  final List<ProfileDetail> details;

  const ProfileData({
    required this.userName,
    required this.profileImageUrl,
    required this.details,
  });
}
