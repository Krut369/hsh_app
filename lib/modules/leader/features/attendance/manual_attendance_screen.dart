import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/features/attendance/attendance_main_screen.dart';
import '../../../../models/attendance_record_model.dart';
import 'package:hsh_app/modules/leader/features/attendance/widgets/student_roster_card.dart';

class ManualAttendanceScreen extends StatelessWidget {
  final AttendanceEventType selectedEvent;

  const ManualAttendanceScreen({super.key, required this.selectedEvent});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LeaderAttendanceController>();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Student Roster',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${controller.roster.length} Students',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final list = controller.filteredRoster;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final student = list[index];
                    return StudentRosterCard(
                      name: student['name'],
                      id: student['id'],
                      status: student['status'],
                      markedPresent: student['marked'].value,
                      onPresent: () => controller.markAttendance(index, true),
                      onAbsent: () => controller.markAttendance(index, false),
                      onUndo: () => controller.undoMarking(index),
                    );
                  },
                );
              }),
            ),
          ],
        ),

        // Sticky Bottom Submit Button
        Positioned(
          bottom: 24,
          left: 24,
          right: 24,
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1D3557),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D3557).withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Attendance submitted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Submit Attendance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.send, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
