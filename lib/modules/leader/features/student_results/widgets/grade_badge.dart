import 'package:flutter/material.dart';

class GradeBadge extends StatelessWidget {
  final String grade;

  const GradeBadge({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final gradeColor = grade.contains('A+')
        ? Colors.green
        : grade.contains('A')
            ? Colors.green
            : grade.contains('B')
                ? Colors.blue
                : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: gradeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        grade,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
