import 'package:flutter/material.dart';
import '../../models/student_result.dart';

class StudentResultDetailScreen extends StatelessWidget {
  final StudentResult result;

  const StudentResultDetailScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        title: Text('${result.studentName}\'s Result'),
        backgroundColor: const Color(0xFF3D5A80),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
                  const SizedBox(height: 16),
                  Text(result.studentName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('ID: ${result.studentId} | Semester: ${result.semester}', style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('CGPA', result.cgpa.toString(), Colors.blue),
                      _buildStat('Grade', result.grade, Colors.green),
                    ],
                  ),
                  const Divider(height: 48),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Subject Wise Marks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  _buildSubjectRow('Mathematics', '95/100'),
                  _buildSubjectRow('Physics', '88/100'),
                  _buildSubjectRow('Chemistry', '92/100'),
                  _buildSubjectRow('Computer Science', '98/100'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildSubjectRow(String subject, String marks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(subject, style: const TextStyle(fontSize: 16)),
          Text(marks, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
