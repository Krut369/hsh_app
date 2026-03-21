import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/attendance_record_model.dart';
import 'qr_attendance_screen.dart';
import 'manual_attendance_screen.dart';
import 'widgets/event_type_chip.dart';

class AttendanceMainScreen extends ConsumerStatefulWidget {
  const AttendanceMainScreen({super.key});

  @override
  ConsumerState<AttendanceMainScreen> createState() => _AttendanceMainScreenState();
}

class _AttendanceMainScreenState extends ConsumerState<AttendanceMainScreen> {
  AttendanceEventType selectedEvent = AttendanceEventType.lunch;
  bool isQrView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5A80),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Attendance',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Event Type Selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: AttendanceEventType.values
                    .where((type) => type != AttendanceEventType.other)
                    .map((type) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: EventTypeChip(
                      label: type.displayName,
                      isSelected: selectedEvent == type,
                      onTap: () => setState(() => selectedEvent = type),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // QR / Manual Toggle
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2D507B).withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isQrView = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isQrView ? const Color(0xFF2D507B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'QR Code',
                          style: TextStyle(
                            color: isQrView ? Colors.white : const Color(0xFF2D507B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isQrView = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isQrView ? const Color(0xFF2D507B) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Manual Entry',
                          style: TextStyle(
                            color: !isQrView ? Colors.white : const Color(0xFF2D507B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Main View
          Expanded(
            child: isQrView
                ? QrAttendanceScreen(selectedEvent: selectedEvent)
                : ManualAttendanceScreen(selectedEvent: selectedEvent),
          ),
        ],
      ),
    );
  }
}
