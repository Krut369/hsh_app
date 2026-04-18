import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/router/leader_auto_router.dart';
import '../../../../../../models/leave_request_model.dart';
import '../controllers/leave_requests_controller.dart';
import '../widgets/leave_request_card.dart';
import '../widgets/filter_chip_widget.dart';
import 'leave_detail_screen.dart';

@RoutePage()
class LeaveRequestsScreen extends GetView<LeaveRequestsController> {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // No need for Get.put anymore as it's provided via LeaderBinding

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
