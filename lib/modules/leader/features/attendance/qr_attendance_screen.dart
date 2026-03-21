import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../models/attendance_record_model.dart';
import 'widgets/attendance_stats_card.dart';

class QrAttendanceScreen extends StatefulWidget {
  final AttendanceEventType selectedEvent;

  const QrAttendanceScreen({super.key, required this.selectedEvent});

  @override
  State<QrAttendanceScreen> createState() => _QrAttendanceScreenState();
}

class _QrAttendanceScreenState extends State<QrAttendanceScreen> {
  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 60; // Refresh
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            'Scan for ${widget.selectedEvent.displayName}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1D3557),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep this screen open for students to scan',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF5D90B3)),
          ),
          const SizedBox(height: 40),
          
          // QR Code Mock
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                // Mock QR Image/Widget
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.qr_code_2, size: 200, color: const Color(0xFF2D507B)),
                      // Animated scanning line or border could go here
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.refresh, size: 16, color: Color(0xFF5D90B3)),
                    const SizedBox(width: 8),
                    Text(
                      'Refreshing in ${_secondsRemaining}s',
                      style: const TextStyle(
                        color: Color(0xFF5D90B3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),
          
          // Stats Row
          const AttendanceStatsCard(
            present: '124',
            absent: '26',
            total: '150',
          ),
        ],
      ),
    );
  }
}
