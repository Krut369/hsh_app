import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/leader_auto_router.dart';
import '../../../../models/attendance_record_model.dart';
import 'qr_attendance_screen.dart';
import 'manual_attendance_screen.dart';
import 'widgets/event_type_chip.dart';

class LeaderAttendanceController extends GetxController {
  final selectedEvent = AttendanceEventType.breakfast.obs;
  final isQrView = true.obs;
  final searchQuery = ''.obs;
  
  // Mock Roster Data
  final roster = <Map<String, dynamic>>[
    {'name': 'Elena Rodriguez', 'id': 'ST-8829', 'status': 'LATE', 'marked': Rxn<bool>()},
    {'name': 'Marcus Thorne', 'id': 'ST-4421', 'status': 'LATE', 'marked': Rxn<bool>()},
    {'name': 'Julianne Vane', 'id': 'ST-3190', 'status': '', 'marked': Rxn<bool>(true)},
    {'name': 'Oliver Twist', 'id': 'ST-1102', 'status': '', 'marked': Rxn<bool>()},
  ].obs;

  List<Map<String, dynamic>> get filteredRoster {
    if (searchQuery.isEmpty) return roster;
    return roster.where((student) => 
      student['name'].toString().toLowerCase().contains(searchQuery.value.toLowerCase()) ||
      student['id'].toString().toLowerCase().contains(searchQuery.value.toLowerCase())
    ).toList();
  }

  void changeEvent(AttendanceEventType event) {
    selectedEvent.value = event;
  }

  void toggleView(bool qr) {
    isQrView.value = qr;
  }

  void markAttendance(int index, bool present) {
    // In a real app, we'd update index based on filtered list mapping back to original
    // For mock, we'll just toggle the Rxn
    roster[index]['marked'].value = present;
  }

  void undoMarking(int index) {
    roster[index]['marked'].value = null;
  }
}

@RoutePage()
class AttendanceMainScreen extends StatelessWidget {
  const AttendanceMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaderAttendanceController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Premium Curved Header
          Obx(() => Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              bottom: 24,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557), // Deep Navy
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.router.back(),
                      ),
                      Expanded(
                        child: Text(
                          controller.isQrView.value ? 'Attendance' : 'Manual Entry',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          controller.isQrView.value ? Icons.history : Icons.search,
                          color: Colors.white,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Event Selection / Search Bar Contextual Section
                if (!controller.isQrView.value)
                  // Manual Entry specific sub-header (Breakfast/Lunch/Dinner)
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D253F),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            _buildTab(controller, AttendanceEventType.breakfast, 'Breakfast'),
                            _buildTab(controller, AttendanceEventType.lunch, 'Lunch'),
                            _buildTab(controller, AttendanceEventType.dinner, 'Dinner'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextField(
                          onChanged: (v) => controller.searchQuery.value = v,
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
                    ],
                  )
                else
                  // QR View specific category bubbles
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: AttendanceEventType.values
                          .where((type) => type != AttendanceEventType.other)
                          .map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: EventTypeChip(
                            label: type.displayName,
                            isSelected: controller.selectedEvent.value == type,
                            onTap: () => controller.changeEvent(type),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          )),

          // Toggle Selection
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Container(
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildToggleButton(
                          label: 'QR Code',
                          isSelected: controller.isQrView.value,
                          onTap: () => controller.toggleView(true),
                        ),
                      ),
                      Expanded(
                        child: _buildToggleButton(
                          label: 'Manual Entry',
                          isSelected: !controller.isQrView.value,
                          onTap: () => controller.toggleView(false),
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

  Widget _buildTab(LeaderAttendanceController controller, AttendanceEventType type, String label) {
    bool isSelected = controller.selectedEvent.value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeEvent(type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1D3557) : Colors.white70,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected 
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1D3557) : const Color(0xFF94A3B8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
