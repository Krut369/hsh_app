import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../models/student_result_model.dart';

class StudentResultsController extends GetxController {
  final studentResults = <StudentResult>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDemoData();
  }

  void _loadDemoData() {
    studentResults.assignAll([
      StudentResult(
        id: '204405',
        studentName: 'Alexander Wright',
        room: '302',
        studentId: '204405',
        cgpa: 9.2,
        grade: 'A+',
        semester: 'Semester 5',
        semesterGpas: [8.5, 8.8, 9.1, 9.2],
        advisorRemarks: "Alexander continues to exhibit exceptional analytical skills, particularly in Computer Science and Mathematics. Recommend exploring honors track for Semester 6.",
        strengths: ["Logical Reasoning", "Problem Solving", "Algorithm Design"],
        improvements: ["Lab Documentation"],
        subjects: {
          'math': SubjectResult(subjectName: 'Mathematics', subTitle: 'Applied Calculus', marks: 95, grade: 'A+', icon: Icons.calculate_outlined),
          'phys': SubjectResult(subjectName: 'Physics', subTitle: 'Quantum Mechanics', marks: 88, grade: 'A', icon: Icons.straighten_outlined),
          'chem': SubjectResult(subjectName: 'Chemistry', subTitle: 'Organic Chemistry', marks: 92, grade: 'A+', icon: Icons.science_outlined),
          'cs': SubjectResult(subjectName: 'Computer Science', subTitle: 'Data Structures', marks: 98, grade: 'A+', icon: Icons.computer_outlined),
        },
      ),
      StudentResult(
        id: '204512',
        studentName: 'Sophia Martinez',
        room: '105',
        studentId: '204512',
        cgpa: 8.8,
        grade: 'A',
        semester: 'Semester 5',
        semesterGpas: [8.2, 8.5, 8.7, 8.8],
        advisorRemarks: "Sophia has shown great consistency. Her dedication to core sciences is commendable.",
        strengths: ["Laboratory Work", "Theoretical Physics"],
        improvements: ["Advanced Calculus"],
        subjects: {
          'math': SubjectResult(subjectName: 'Mathematics', subTitle: 'Linear Algebra', marks: 82, grade: 'B+', icon: Icons.calculate_outlined),
          'phys': SubjectResult(subjectName: 'Physics', subTitle: 'Electromagnetism', marks: 94, grade: 'A+', icon: Icons.straighten_outlined),
          'chem': SubjectResult(subjectName: 'Chemistry', subTitle: 'Inorganic Chemistry', marks: 90, grade: 'A', icon: Icons.science_outlined),
        },
      ),
      StudentResult(
        id: '204398',
        studentName: 'Julian Lee',
        room: '302',
        studentId: '204398',
        cgpa: 7.9,
        grade: 'B+',
        semester: 'Semester 5',
        semesterGpas: [7.2, 7.5, 7.8, 7.9],
        advisorRemarks: "Julian is making steady progress. Focused study in Mathematics will further improve his average.",
        strengths: ["System Design", "Technical Writing"],
        improvements: ["Mathematics Fundamentals"],
        subjects: {
          'math': SubjectResult(subjectName: 'Mathematics', subTitle: 'Calculus II', marks: 68, grade: 'C+', icon: Icons.calculate_outlined),
          'cs': SubjectResult(subjectName: 'Computer Science', subTitle: 'Database Systems', marks: 88, grade: 'A', icon: Icons.computer_outlined),
        },
      ),
      StudentResult(
        id: '204667',
        studentName: 'Elena Chen',
        room: '210',
        studentId: '204667',
        cgpa: 9.5,
        grade: 'A+',
        semester: 'Semester 5',
        semesterGpas: [9.0, 9.2, 9.4, 9.5],
        advisorRemarks: "Elena is a top-tier performer across all disciplines. Her research initiative is outstanding.",
        strengths: ["Critical Thinking", "Complex Analysis", "Research"],
        improvements: ["Public Speaking"],
        subjects: {
          'math': SubjectResult(subjectName: 'Mathematics', subTitle: 'Discrete Math', marks: 97, grade: 'A+', icon: Icons.calculate_outlined),
          'cs': SubjectResult(subjectName: 'Computer Science', subTitle: 'AI Fundamentals', marks: 96, grade: 'A+', icon: Icons.computer_outlined),
        },
      ),
    ]);
  }

  List<StudentResult> get filteredResults {
    if (searchQuery.value.isEmpty) return studentResults;
    return studentResults
        .where((r) =>
            r.studentName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            r.studentId
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}
