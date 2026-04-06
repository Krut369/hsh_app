import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:uitoolkit/uitoolkit.dart' as ui;

class TimelineEvent {
  final String title;
  final String subtitle;
  final DateTime dateTime;
  final bool isCompleted;
  final bool isActive;
  final IconData icon;

  TimelineEvent({
    required this.title,
    required this.subtitle,
    required this.dateTime,
    this.isCompleted = false,
    this.isActive = false,
    required this.icon,
  });
}

class ComplaintDetailsScreen extends StatelessWidget {
  final Complaint complaint;

  const ComplaintDetailsScreen({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: const Color(0xFFF0F5F9), // Lighter blue-grey background
      body: Column(
        children: [
          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              child: Column(
                children: [
                  // Integrated Info Card
                  _buildMainInfoCard(context),

                  const SizedBox(height: 24),

                  // Activity Timeline Card
                  _buildTimelineCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 16,
        left: 8,
        right: 16,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBlue,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Expanded(
            child: ui.ModernText(
              "Complaint Details",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Balancing width of the back button
        ],
      ),
    );
  }

  Widget _buildMainInfoCard(BuildContext context) {
    final statusColor =
        ComplaintUtils.getStatusColor(context, complaint.status);
    final categoryIconColor = _getCategoryIconColor(complaint.complaintType);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Circle
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: categoryIconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ComplaintUtils.getComplaintTypeIcon(complaint.complaintType),
                  color: categoryIconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ui.ModernText(
                      complaint.complaintType.toUpperCase(),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade500,
                      letterSpacing: 0.5,
                    ),
                    const SizedBox(height: 4),
                    ui.ModernText(
                      complaint.issues.entries.first.key,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headerBlue,
                      height: 1.2,
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ui.ModernText(
                  complaint.status.label.toUpperCase(),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Date & Time
          Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 8),
              ui.ModernText(
                DateFormat('MMM dd, yyyy • hh:mm A').format(complaint.dateTime),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade500,
              ),
            ],
          ),

          const SizedBox(height: 24),
          Divider(height: 1, color: Colors.grey.shade100),
          const SizedBox(height: 20),

          // Description Header
          ui.ModernText(
            "DESCRIPTION",
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
            letterSpacing: 0.5,
          ),
          const SizedBox(height: 10),

          // Description Text
          ui.ModernText(
            complaint.issues.entries.first.value.description,
            fontSize: 14,
            color: Colors.grey.shade700,
            height: 1.6,
          ),

          if (complaint.issues.entries.first.value.imagePath != null) ...[
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(complaint.issues.entries.first.value.imagePath!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineCard(BuildContext context) {
    final events = _generateTimelineEvents(complaint);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ui.ModernText(
            "Activity Timeline",
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _TimelineNode(
                event: events[index],
                isFirst: index == 0,
                isLast: index == events.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }

  List<TimelineEvent> _generateTimelineEvents(Complaint complaint) {
    List<TimelineEvent> events = [];
    final now = complaint.dateTime;

    // Step 1: Submitted
    events.add(TimelineEvent(
      title: "Complaint Submitted",
      subtitle: "Successfully logged into the system.",
      dateTime: now,
      isCompleted: true,
      icon: Icons.check,
    ));

    // Step 2: Assigned (if status is not pending)
    if (complaint.status != ComplaintStatus.pending) {
      events.add(TimelineEvent(
        title: "Assigned to Maintenance",
        subtitle: "Assigned to: Technician John Doe",
        dateTime: now.add(const Duration(hours: 1)),
        isCompleted: true,
        icon: Icons.check,
      ));
    } else {
      events.add(TimelineEvent(
        title: "Assigned to Maintenance",
        subtitle: "Waiting for assignment",
        dateTime: now.add(const Duration(hours: 1)),
        icon: Icons.circle_outlined,
      ));
    }

    // Step 3: Under Review / In Progress
    if (complaint.status == ComplaintStatus.underReview ||
        complaint.status == ComplaintStatus.awaitingFeedback ||
        complaint.status == ComplaintStatus.resolved) {
      events.add(TimelineEvent(
        title: "Under Review",
        subtitle: "Maintenance team is assessing the motor fault.",
        dateTime: now.add(const Duration(hours: 2)),
        isCompleted: complaint.status == ComplaintStatus.resolved,
        isActive: complaint.status == ComplaintStatus.underReview ||
            complaint.status == ComplaintStatus.awaitingFeedback,
        icon: complaint.status == ComplaintStatus.resolved
            ? Icons.check
            : Icons.visibility,
      ));
    } else {
      events.add(TimelineEvent(
        title: "Under Review",
        subtitle: "Pending review",
        dateTime: now.add(const Duration(hours: 2)),
        icon: Icons.circle_outlined,
      ));
    }

    // Step 4: Resolved
    events.add(TimelineEvent(
      title: "Resolved",
      subtitle: complaint.status == ComplaintStatus.resolved
          ? "The issue has been successfully resolved."
          : "Expected completion: Today",
      dateTime: now.add(const Duration(hours: 4)),
      isCompleted: complaint.status == ComplaintStatus.resolved,
      isActive: false,
      icon: complaint.status == ComplaintStatus.resolved
          ? Icons.check
          : Icons.check_circle_outline,
    ));

    return events;
  }

  Color _getCategoryIconColor(String type) {
    switch (type) {
      case 'Electrical':
        return Colors.amber;
      case 'Plumbing':
        return Colors.blue;
      case 'Carpentry':
        return Colors.brown;
      default:
        return AppColors.headerBlue;
    }
  }
}

class _TimelineNode extends StatelessWidget {
  final TimelineEvent event;
  final bool isFirst;
  final bool isLast;

  const _TimelineNode({
    required this.event,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = const Color(0xFF3B82F6);
    final completedColor = const Color(0xFF10B981);
    final upcomingColor = Colors.grey.shade200;

    Color nodeColor = upcomingColor;
    Color iconColor = Colors.grey.shade400;

    if (event.isCompleted) {
      nodeColor = completedColor;
      iconColor = Colors.white;
    } else if (event.isActive) {
      nodeColor = activeColor;
      iconColor = Colors.white;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Indicator
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: nodeColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(event.icon, size: 16, color: iconColor),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      color: upcomingColor,
                      gradient: event.isCompleted
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [completedColor, upcomingColor],
                            )
                          : null,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ui.ModernText(
                    event.title,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: event.isActive || event.isCompleted
                        ? AppColors.headerBlue
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 4),
                  ui.ModernText(
                    DateFormat('MMM dd, yyyy • hh:mm A').format(event.dateTime),
                    fontSize: 11,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  ui.ModernText(
                    event.subtitle,
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
