import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/models/leave_request_model.dart';
import 'widgets/leave_request_card.dart';
import 'widgets/filter_chip_widget.dart';
import 'leave_detail_screen.dart';

// Demo data provider
final leaveRequestsProvider = StateProvider<List<LeaveRequest>>((ref) => [
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

final selectedLeaveFilterProvider = StateProvider<LeaveStatus?>((ref) => null);

class LeaveRequestsScreen extends ConsumerWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRequests = ref.watch(leaveRequestsProvider);
    final selectedFilter = ref.watch(selectedLeaveFilterProvider);

    final filteredRequests = selectedFilter == null
        ? allRequests
        : allRequests.where((r) => r.status == selectedFilter).toList();

    final pendingCount = allRequests.where((r) => r.status == LeaveStatus.pending).length;

    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2D507B)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Leave Requests',
          style: TextStyle(
            color: Color(0xFF1D3557),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF2D507B)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChipWidget(
                    label: 'All',
                    status: null,
                    isSelected: selectedFilter == null,
                    onTap: (LeaveStatus? s) => ref.read(selectedLeaveFilterProvider.notifier).state = s,
                  ),
                  const SizedBox(width: 8),
                  FilterChipWidget(
                    label: 'Pending',
                    status: LeaveStatus.pending,
                    isSelected: selectedFilter == LeaveStatus.pending,
                    count: pendingCount,
                    onTap: (LeaveStatus? s) => ref.read(selectedLeaveFilterProvider.notifier).state = s,
                  ),
                  const SizedBox(width: 8),
                  FilterChipWidget(
                    label: 'Approved',
                    status: LeaveStatus.approved,
                    isSelected: selectedFilter == LeaveStatus.approved,
                    onTap: (LeaveStatus? s) => ref.read(selectedLeaveFilterProvider.notifier).state = s,
                  ),
                  const SizedBox(width: 8),
                  FilterChipWidget(
                    label: 'Rejected',
                    status: LeaveStatus.rejected,
                    isSelected: selectedFilter == LeaveStatus.rejected,
                    onTap: (LeaveStatus? s) => ref.read(selectedLeaveFilterProvider.notifier).state = s,
                  ),
                ],
              ),
            ),
          ),

          // Requests List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredRequests.length,
              itemBuilder: (context, index) {
                final request = filteredRequests[index];
                return LeaveRequestCard(
                  request: request,
                  onApprove: (LeaveRequest r) => _approveRequest(ref, r),
                  onReject: (LeaveRequest r) => _rejectRequest(ref, r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaveDetailScreen(
                          request: request,
                          onApprove: (LeaveRequest r) => _approveRequest(ref, r),
                          onReject: (LeaveRequest r) => _rejectRequest(ref, r),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _approveRequest(WidgetRef ref, LeaveRequest request) {
    final requests = ref.read(leaveRequestsProvider);
    final updatedRequests = requests.map((r) {
      if (r.id == request.id) {
        return r.copyWith(status: LeaveStatus.approved, processedAt: DateTime.now());
      }
      return r;
    }).toList();
    ref.read(leaveRequestsProvider.notifier).state = updatedRequests;
  }

  void _rejectRequest(WidgetRef ref, LeaveRequest request) {
    final requests = ref.read(leaveRequestsProvider);
    final updatedRequests = requests.map((r) {
      if (r.id == request.id) {
        return r.copyWith(status: LeaveStatus.rejected, processedAt: DateTime.now());
      }
      return r;
    }).toList();
    ref.read(leaveRequestsProvider.notifier).state = updatedRequests;
  }
}
