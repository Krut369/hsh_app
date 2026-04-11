import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../models/attendance_record_model.dart';
import 'qr_attendance_screen.dart';
import 'manual_attendance_screen.dart';
import 'widgets/event_type_chip.dart';

class LeaderAttendanceController extends GetxController {
  final selectedEvent = AttendanceEventType.lunch.obs;
  final isQrView = true.obs;

  void changeEvent(AttendanceEventType event) {
    selectedEvent.value = event;
  }

  void toggleView(bool qr) {
    isQrView.value = qr;
  }
}

class AttendanceMainScreen extends StatelessWidget {
  const AttendanceMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderAttendanceController());

    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5A80),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Attendance',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.history, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(() => Row(
                    children: AttendanceEventType.values
                        .where((type) => type != AttendanceEventType.other)
                        .map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: EventTypeChip(
                          label: type.displayName,
                          isSelected: controller.selectedEvent.value == type,
                          onTap: () => controller.changeEvent(type),
                        ),
                      );
                    }).toList(),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: const Color(0xFF2D507B).withValues(alpha: 0.2))),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleView(true),
                          child: Container(
                            decoration: BoxDecoration(
                                color: controller.isQrView.value
                                    ? const Color(0xFF2D507B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Text('QR Code',
                                style: TextStyle(
                                    color: controller.isQrView.value
                                        ? Colors.white
                                        : const Color(0xFF2D507B),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => controller.toggleView(false),
                          child: Container(
                            decoration: BoxDecoration(
                                color: !controller.isQrView.value
                                    ? const Color(0xFF2D507B)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10)),
                            alignment: Alignment.center,
                            child: Text('Manual Entry',
                                style: TextStyle(
                                    color: !controller.isQrView.value
                                        ? Colors.white
                                        : const Color(0xFF2D507B),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: Obx(() => controller.isQrView.value
                ? QrAttendanceScreen(
                    selectedEvent: controller.selectedEvent.value)
                : ManualAttendanceScreen(
                    selectedEvent: controller.selectedEvent.value)),
          ),
        ],
      ),
    );
  }
}
