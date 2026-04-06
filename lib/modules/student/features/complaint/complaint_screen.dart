import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/student/features/complaint/widgets/complaint_card.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_details_screen.dart';
import 'package:uitoolkit/uitoolkit.dart' as ui;

class ComplaintScreen extends GetView<ComplainController> {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: AppColors.mainBackground,
      floatingActionButton: FloatingActionButton(
        heroTag: 'complaint_fab',
        onPressed: () => Get.toNamed('/student/complaint/add'),
        backgroundColor: AppColors.headerBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // Custom Header
          _buildHeader(context),

          // Complaint List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.complaints.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              var complaintsList = controller.filteredComplaints;
              if (complaintsList.isEmpty) {
                final List<Map<String, dynamic>> dummyComplaintsJson = [
                  {
                    "id": "CMP001",
                    "createdAt": "2026-03-25T10:30:00Z",
                    "category": {"name": "Electricity"},
                    "status": "PENDING",
                    "issues": [
                      {
                        "subCategory": {"name": "Power Cut"},
                        "description": "Frequent power cuts in area",
                        "priority": "HIGH"
                      },
                      {
                        "subCategory": {"name": "Voltage Issue"},
                        "description": "Low voltage during night",
                        "priority": "MEDIUM"
                      }
                    ]
                  },
                  {
                    "id": "CMP002",
                    "createdAt": "2026-03-24T14:15:00Z",
                    "category": {"name": "Water"},
                    "status": "UNDER_REVIEW",
                    "issues": [
                      {
                        "subCategory": {"name": "No Supply"},
                        "description": "No water supply since morning",
                        "priority": "HIGH"
                      }
                    ]
                  },
                  {
                    "id": "CMP003",
                    "createdAt": "2026-03-23T09:00:00Z",
                    "category": {"name": "Road"},
                    "status": "RESOLVED",
                    "issues": [
                      {
                        "subCategory": {"name": "Potholes"},
                        "description": "Large potholes near main road",
                        "priority": "LOW"
                      }
                    ]
                  },
                  {
                    "id": "CMP004",
                    "createdAt": "2026-03-22T18:45:00Z",
                    "category": {"name": "Sanitation"},
                    "status": "AWAITING_FEEDBACK",
                    "issues": [
                      {
                        "subCategory": {"name": "Garbage Collection"},
                        "description": "Garbage not collected for 3 days",
                        "priority": "MEDIUM"
                      }
                    ]
                  }
                ];

                complaintsList = dummyComplaintsJson
                    .map((json) => Complaint.fromJson(json))
                    .toList();
              }

              if (complaintsList.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                onRefresh: () async {
                  controller.fetchComplaints();
                  controller.fetchStats();
                },
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  itemCount: complaintsList.length,
                  itemBuilder: (context, index) {
                    return ComplaintCard(
                      complaint: complaintsList[index],
                      onTap: () =>
                          _showComplaintDetails(context, complaintsList[index]),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ui.ModernText(
            "Complaint",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          _buildFilterButton(context),
        ],
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showFilterDialog(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.filter_alt_outlined,
                    color: AppColors.headerBlue, size: 15),
                const SizedBox(width: 8),
                ui.ModernText(
                  controller.filter.value?.label ?? "All",
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Icon(Icons.history_edu, size: 64, color: Colors.grey[300]),
          ),
          const SizedBox(height: 24),
          const ui.ModernText(
            "No complaints found",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
          const SizedBox(height: 8),
          ui.ModernText(
            "Have an issue? Raise a ticket now.",
            fontSize: 14,
            color: Colors.grey[500]!,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ui.ModernText(
              "Filter Complaints",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.headerBlue,
            ),
            const SizedBox(height: 20),
            _buildFilterOption(null, "All"),
            ...ComplaintStatus.values
                .map((status) => _buildFilterOption(status, status.label)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(ComplaintStatus? status, String label) {
    return Obx(() {
      final isSelected = controller.filter.value == status;
      return ListTile(
        onTap: () {
          controller.setFilter(status);
          Get.back();
        },
        leading: Icon(
          isSelected ? Icons.check_circle : Icons.circle_outlined,
          color: isSelected ? AppColors.pendingBlue : Colors.grey,
        ),
        title: ui.ModernText(
          label,
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: AppColors.headerBlue,
        ),
      );
    });
  }

  void _showComplaintDetails(BuildContext context, Complaint complaint) {
    Get.to(() => ComplaintDetailsScreen(complaint: complaint));
  }
}
