import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hsh_app/models/leave_request_model.dart';
import 'widgets/leave_request_card.dart';
import 'widgets/filter_chip_widget.dart';
import 'leave_detail_screen.dart';

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
        studentName: 'Aditi Sharma',
        studentAvatar: '',
        room: '205',
        leaveType: 'Home Visit Request',
        startDate: DateTime(2023, 10, 12),
        endDate: DateTime(2023, 10, 15),
        reason: 'Family function at home',
        status: LeaveStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      LeaveRequest(
        id: 'RV901',
        studentId: '002',
        studentName: 'Rahul Verma',
        studentAvatar: '',
        room: '108',
        leaveType: 'Home Visit Request',
        startDate: DateTime(2023, 10, 14),
        endDate: DateTime(2023, 10, 16),
        reason: 'Medical checkup',
        status: LeaveStatus.pending,
        appliedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      LeaveRequest(
        id: 'SK123',
        studentId: '003',
        studentName: 'Sanya Kapoor',
        studentAvatar: '',
        room: '302',
        leaveType: 'Home Visit Request',
        startDate: DateTime(2023, 10, 10),
        endDate: DateTime(2023, 10, 11),
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

class LeaveRequestsScreen extends StatelessWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveRequestsController());

    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D507B)),
          onPressed: () => context.pop(),
        ),
        title: const Text('Leave Requests',
            style: TextStyle(
                color: Color(0xFF1D3557),
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF2D507B)),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() => Row(
                    children: [
                      FilterChipWidget(
                        label: 'All',
                        status: null,
                        isSelected: controller.selectedFilter.value == null,
                        onTap: controller.setFilter,
                      ),
                      const SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'Pending',
                        status: LeaveStatus.pending,
                        isSelected: controller.selectedFilter.value ==
                            LeaveStatus.pending,
                        count: controller.pendingCount,
                        onTap: controller.setFilter,
                      ),
                      const SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'Approved',
                        status: LeaveStatus.approved,
                        isSelected: controller.selectedFilter.value ==
                            LeaveStatus.approved,
                        onTap: controller.setFilter,
                      ),
                      const SizedBox(width: 8),
                      FilterChipWidget(
                        label: 'Rejected',
                        status: LeaveStatus.rejected,
                        isSelected: controller.selectedFilter.value ==
                            LeaveStatus.rejected,
                        onTap: controller.setFilter,
                      ),
                    ],
                  )),
            ),
          ),
          Expanded(
            child: Obx(() {
              final requests = controller.filteredRequests;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return LeaveRequestCard(
                    request: request,
                    onApprove: controller.approveRequest,
                    onReject: controller.rejectRequest,
                    onTap: () {
                      Get.to(() => LeaveDetailScreen(
                            request: request,
                            onApprove: controller.approveRequest,
                            onReject: controller.rejectRequest,
                          ));
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
}
