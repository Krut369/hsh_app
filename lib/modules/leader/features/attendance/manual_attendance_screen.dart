import 'package:flutter/material.dart';
import '../../../../models/attendance_record_model.dart';
import 'widgets/student_detail_card.dart';

class ManualAttendanceScreen extends StatefulWidget {
  final AttendanceEventType selectedEvent;

  const ManualAttendanceScreen({super.key, required this.selectedEvent});

  @override
  State<ManualAttendanceScreen> createState() => _ManualAttendanceScreenState();
}

class _ManualAttendanceScreenState extends State<ManualAttendanceScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _showStudentDetail = false;

  // Mock student data
  final Map<String, dynamic> _mockStudent = {
    'name': 'Rahul Patel',
    'id': 'SH772',
    'room': '205',
    'block': 'A',
    'photo': 'assets/images/student_placeholder.png' // Mock path
  };

  void _onSearch() {
    if (_codeController.text.isNotEmpty) {
      setState(() {
        _showStudentDetail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Student Code',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'e.g. 772',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _onSearch(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _onSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2D507B),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.search),
              ),
            ],
          ),
          const SizedBox(height: 32),
          if (_showStudentDetail) ...[
            StudentDetailCard(
              student: _mockStudent,
              onMarkPresent: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Attendance marked successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {
                  _showStudentDetail = false;
                  _codeController.clear();
                });
              },
            ),
          ] else ...[
            const SizedBox(height: 60),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_search,
                        size: 80, color: Color(0xFFD6ECF7)),
                    SizedBox(height: 16),
                    Text(
                      'Search for a student to mark attendance',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF5D90B3)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
