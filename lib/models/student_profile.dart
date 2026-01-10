import 'package:flutter/material.dart';


class StudentProfile {
  final String name;
  final String college;
  final String room;
  final String id;
  final String imagePath;
  StudentProfile({
    required this.name,
    required this.college,
    required this.room,
    required this.id,
    required this.imagePath,
  });
}