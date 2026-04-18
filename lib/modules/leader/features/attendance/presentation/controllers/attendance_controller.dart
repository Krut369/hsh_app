import 'package:get/get.dart';
import '../../../../../../models/attendance_record_model.dart';

class LeaderAttendanceController extends GetxController {
  final selectedEvent = AttendanceEventType.breakfast.obs;
  final isQrView = true.obs;
  final searchQuery = ''.obs;

  // Mock Roster Data
  final roster = <Map<String, dynamic>>[
    {
      'name': 'Elena Rodriguez',
      'id': 'ST-8829',
      'status': 'LATE',
      'marked': Rxn<bool>()
    },
    {
      'name': 'Marcus Thorne',
      'id': 'ST-4421',
      'status': 'LATE',
      'marked': Rxn<bool>()
    },
    {
      'name': 'Julianne Vane',
      'id': 'ST-3190',
      'status': '',
      'marked': Rxn<bool>(true)
    },
    {
      'name': 'Oliver Twist',
      'id': 'ST-1102',
      'status': '',
      'marked': Rxn<bool>()
    },
  ].obs;

  List<Map<String, dynamic>> get filteredRoster {
    if (searchQuery.isEmpty) return roster;
    return roster
        .where((student) =>
            student['name']
                .toString()
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            student['id']
                .toString()
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void changeEvent(AttendanceEventType event) {
    selectedEvent.value = event;
  }

  void toggleView(bool qr) {
    isQrView.value = qr;
  }

  void markAttendance(int index, bool present) {
    roster[index]['marked'].value = present;
  }

  void undoMarking(int index) {
    roster[index]['marked'].value = null;
  }

  // Statistics
  int get totalCount => roster.length;
  int get presentCount => roster.where((s) => s['marked'].value == true).length;
  int get absentCount => roster.where((s) => s['marked'].value == false).length;

  // Actions
  Future<bool> submitAttendance() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }
}
