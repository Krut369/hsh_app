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
      if (mounted) {
        setState(() {
          if (_secondsRemaining > 0) {
            _secondsRemaining--;
          } else {
            _secondsRemaining = 60; // Refresh
          }
        });
      }
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // QR Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1D3557).withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    'https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=HostelHub_Attendance_${widget.selectedEvent.name}',
                    width: 200,
                    height: 200,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.qr_code_2,
                      size: 200,
                      color: Color(0xFF1D3557),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.sync, size: 18, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 8),
                    Text(
                      'Refreshing in 0:${_secondsRemaining.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // Stats Area
          const AttendanceStatsCard(
            total: '128',
            present: '112',
            absent: '16',
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
