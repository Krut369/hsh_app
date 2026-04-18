import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/leader_auto_router.dart';
import 'package:hsh_app/models/student_result_model.dart';
import 'widgets/result_card.dart';
import 'student_result_detail_screen.dart';

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
        .where((r) => r.studentName
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }
}

@RoutePage()
class StudentResultsScreen extends StatelessWidget {
  const StudentResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentResultsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Premium Curved Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 32,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557), // Deep Navy
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.router.back(),
                      ),
                      const Expanded(
                        child: Text(
                          'Student Performance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: TextField(
                    onChanged: controller.updateSearch,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search student name or ID...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _buildFilterChip('All Students', true),
                      const SizedBox(width: 12),
                      _buildFilterChip('By Room', false),
                      const SizedBox(width: 12),
                      _buildFilterChip('Block A', false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              final results = controller.filteredResults;
              return ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  return ResultCard(
                    result: result,
                    onViewReport: () {
                      Get.to(() => StudentResultDetailScreen(result: result));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0D253F) : Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : const Color(0xFF1D3557),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
