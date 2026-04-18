import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/router/leader_auto_router.dart';
import '../../../../../../models/student_result_model.dart';
import '../controllers/student_results_controller.dart';
import '../widgets/result_card.dart';
import 'student_result_detail_screen.dart';

@RoutePage()
class StudentResultsScreen extends GetView<StudentResultsController> {
  const StudentResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No need for Get.put anymore as it's provided via LeaderBinding

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
