import 'package:flutter/material.dart';
import '../../../models/student_result.dart';
import 'grade_badge.dart';

class ResultCard extends StatelessWidget {
  final StudentResult result;
  final VoidCallback onViewReport;

  const ResultCard({
    super.key,
    required this.result,
    required this.onViewReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.studentName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ROOM ${result.room} | ID: ${result.studentId}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5D90B3),
                      ),
                    ),
                  ],
                ),
              ),
              GradeBadge(grade: result.grade),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    result.cgpa.toString(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _getGradeColor(result.grade),
                    ),
                  ),
                  const Text(
                    'CGPA',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5D90B3),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton.icon(
              onPressed: onViewReport,
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: const Text('View Full Report'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2D507B),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
     if (grade.contains('A+')) return Colors.green;
     if (grade.contains('A')) return Colors.green;
     return Colors.orange;
  }
}
