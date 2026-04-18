import 'package:get/get.dart';
import '../../../../../../models/leave_request_model.dart';

class LeaveRequestsController extends GetxController {
  final allRequests = <LeaveRequest>[].obs;
  final selectedFilter = Rxn<LeaveStatus>();

  @override
  void onInit() {
    super.onInit();
    _loadDemoData();
  }

  void _loadDemoData() {
    allRequests.assignAll([
      LeaveRequest(
        id: 'SH772',
        studentId: '001',
        studentName: 'Julian Alexander',
        studentAvatar: 'assets/julian_avatar.png',
        room: '205',
        leaveType: 'Home Visit',
        startDate: DateTime(2023, 10, 24),
        endDate: DateTime(2023, 10, 26),
        reason: 'Family function at home',
        status: LeaveStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LeaveRequest(
        id: 'RV901',
        studentId: '002',
        studentName: 'Maya Thompson',
        studentAvatar: 'assets/maya_avatar.png',
        room: '108',
        leaveType: 'Medical Leave',
        startDate: DateTime(2023, 10, 25),
        endDate: DateTime(2023, 10, 25),
        reason: 'Medical checkup',
        status: LeaveStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LeaveRequest(
        id: 'SK123',
        studentId: '003',
        studentName: 'Ethan Wright',
        studentAvatar: 'assets/ethan_avatar.png',
        room: '302',
        leaveType: 'Special Event',
        startDate: DateTime(2023, 10, 20),
        endDate: DateTime(2023, 10, 21),
        reason: 'Personal work',
        status: LeaveStatus.approved,
        appliedAt: DateTime.now().subtract(const Duration(days: 1)),
        processedAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
    ]);
  }

  List<LeaveRequest> get filteredRequests {
    if (selectedFilter.value == null) return allRequests;
    return allRequests.where((r) => r.status == selectedFilter.value).toList();
  }

  int get pendingCount =>
      allRequests.where((r) => r.status == LeaveStatus.pending).length;

  void setFilter(LeaveStatus? status) {
    selectedFilter.value = status;
  }

  void approveRequest(LeaveRequest request) {
    final index = allRequests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      allRequests[index] = allRequests[index].copyWith(
        status: LeaveStatus.approved,
        processedAt: DateTime.now(),
      );
    }
  }

  void rejectRequest(LeaveRequest request) {
    final index = allRequests.indexWhere((r) => r.id == request.id);
    if (index != -1) {
      allRequests[index] = allRequests[index].copyWith(
        status: LeaveStatus.rejected,
        processedAt: DateTime.now(),
      );
    }
  }
}
