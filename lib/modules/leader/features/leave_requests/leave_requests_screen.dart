import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/leader_auto_router.dart';
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

@RoutePage()
class LeaveRequestsScreen extends StatelessWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LeaveRequestsController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          // Premium Curved Header
          Container(
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
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {},
                      ),
                      const Expanded(
                        child: Text(
                          'Leave Requests',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications_none,
                                color: Colors.white, size: 28),
                            onPressed: () {},
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: const Color(0xFF1D3557), width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Filter Chips inside Header
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(() => Row(
                        children: [
                          FilterChipWidget(
                            label: 'All',
                            status: null,
                            isSelected: controller.selectedFilter.value == null,
                            onTap: controller.setFilter,
                          ),
                          const SizedBox(width: 12),
                          FilterChipWidget(
                            label: 'Pending',
                            status: LeaveStatus.pending,
                            isSelected: controller.selectedFilter.value ==
                                LeaveStatus.pending,
                            onTap: controller.setFilter,
                          ),
                          const SizedBox(width: 12),
                          FilterChipWidget(
                            label: 'Approved',
                            status: LeaveStatus.approved,
                            isSelected: controller.selectedFilter.value ==
                                LeaveStatus.approved,
                            onTap: controller.setFilter,
                          ),
                          const SizedBox(width: 12),
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
              ],
            ),
          ),

          Expanded(
            child: Obx(() {
              final requests = controller.filteredRequests;
              if (requests.isEmpty) {
                return const Center(child: Text('No leave requests found'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(24),
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
