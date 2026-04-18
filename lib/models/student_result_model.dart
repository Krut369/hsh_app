import 'package:flutter/material.dart';

class StudentResult {
  final String id;
  final String studentName;
  final String room;
  final String studentId;
  final double cgpa;
  final String grade;
  final String semester;
  final Map<String, SubjectResult> subjects;
  final List<double> semesterGpas;
  final String advisorRemarks;
  final List<String> strengths;
  final List<String> improvements;

  StudentResult({
    required this.id,
    required this.studentName,
    required this.room,
    required this.studentId,
    required this.cgpa,
    required this.grade,
    required this.semester,
    required this.subjects,
    this.semesterGpas = const [],
    this.advisorRemarks = '',
    this.strengths = const [],
    this.improvements = const [],
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'studentName': studentName,
        'room': room,
        'studentId': studentId,
        'cgpa': cgpa,
        'grade': grade,
        'semester': semester,
        'subjects': subjects.map((key, value) => MapEntry(key, value.toMap())),
        'semesterGpas': semesterGpas,
        'advisorRemarks': advisorRemarks,
        'strengths': strengths,
        'improvements': improvements,
      };

  factory StudentResult.fromMap(Map<String, dynamic> map) => StudentResult(
        id: map['id'],
        studentName: map['studentName'],
        room: map['room'],
        studentId: map['studentId'],
        cgpa: map['cgpa'].toDouble(),
        grade: map['grade'],
        semester: map['semester'],
        subjects: Map<String, SubjectResult>.from(
          (map['subjects'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, SubjectResult.fromMap(value)),
          ),
        ),
        semesterGpas: List<double>.from(map['semesterGpas'] ?? []),
        advisorRemarks: map['advisorRemarks'] ?? '',
        strengths: List<String>.from(map['strengths'] ?? []),
        improvements: List<String>.from(map['improvements'] ?? []),
      );
}

class SubjectResult {
  final String subjectName;
  final String subTitle;
  final double marks;
  final String grade;
  final IconData icon;

  SubjectResult({
    required this.subjectName,
    this.subTitle = '',
    required this.marks,
    required this.grade,
    this.icon = Icons.book,
  });

  Map<String, dynamic> toMap() => {
        'subjectName': subjectName,
        'subTitle': subTitle,
        'marks': marks,
        'grade': grade,
      };

  factory SubjectResult.fromMap(Map<String, dynamic> map) => SubjectResult(
        subjectName: map['subjectName'],
        subTitle: map['subTitle'] ?? '',
        marks: map['marks'].toDouble(),
        grade: map['grade'],
      );
}
