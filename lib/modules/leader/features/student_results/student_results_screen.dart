import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/models/student_result_model.dart';
import 'widgets/result_card.dart';
import 'student_result_detail_screen.dart';

// Demo data provider
final studentResultsProvider = StateProvider<List<StudentResult>>((ref) => [
      StudentResult(
        id: '204405',
        studentName: 'Alexander Wright',
        room: '302',
        studentId: '204405',
        cgpa: 9.2,
        grade: 'A+',
        semester: 'Semester 5',
        subjects: {},
      ),
      StudentResult(
        id: '204412',
        studentName: 'Sarah Jenkins',
        room: '105',
        studentId: '204412',
        cgpa: 8.8,
        grade: 'A+',
        semester: 'Semester 5',
        subjects: {},
      ),
      StudentResult(
        id: '204488',
        studentName: 'Marcus Thorne',
        room: '412',
        studentId: '204488',
        cgpa: 9.0,
        grade: 'A',
        semester: 'Semester 5',
        subjects: {},
      ),
      StudentResult(
        id: '204419',
        studentName: 'Elena Rodriguez',
        room: '202',
        studentId: '204419',
        cgpa: 9.5,
        grade: 'A+',
        semester: 'Semester 5',
        subjects: {},
      ),
    ]);

class StudentResultsScreen extends ConsumerStatefulWidget {
  const StudentResultsScreen({super.key});

  @override
  ConsumerState<StudentResultsScreen> createState() => _StudentResultsScreenState();
}

class _StudentResultsScreenState extends ConsumerState<StudentResultsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(studentResultsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1D3557)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Student Results',
          style: TextStyle(
            color: Color(0xFF1D3557),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: const TextStyle(color: Color(0xFF5D90B3)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF5D90B3)),
                filled: true,
                fillColor: const Color(0xFFF6FAFD),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                _buildFilterDropdown('All Students'),
                const SizedBox(width: 8),
                _buildFilterDropdown('By Room'),
                const SizedBox(width: 8),
                _buildFilterDropdown('Block A'),
              ],
            ),
          ),

          // Results List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final result = results[index];
                return ResultCard(
                  result: result,
                  onViewReport: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentResultDetailScreen(result: result),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2D507B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
