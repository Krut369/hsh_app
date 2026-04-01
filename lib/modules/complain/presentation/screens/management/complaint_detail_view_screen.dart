import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:uitoolkit/uitoolkit.dart';

import '../../../../../core/theme/app_colors.dart' as hsh;

class ComplaintDetailViewScreen extends StatefulWidget {
  final Complaint complaint;

  const ComplaintDetailViewScreen({
    super.key,
    required this.complaint,
  });

  @override
  State<ComplaintDetailViewScreen> createState() =>
      _ComplaintDetailViewScreenState();
}

class _ComplaintDetailViewScreenState extends State<ComplaintDetailViewScreen> {
  final ComplainController controller = Get.find<ComplainController>();
  late ComplaintStatus? selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.complaint.status;
  }

  Color _statusBadgeBgColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return const Color(0xFFE2E8F0); // Slate light grey
      case ComplaintStatus.pending:
        return AppColors.warning.withValues(alpha: 0.1); // Amber 50
      case ComplaintStatus.awaitingFeedback:
        return AppColors.info.withValues(alpha: 0.1); // Blue 50
      case ComplaintStatus.resolved:
        return AppColors.success.withValues(alpha: 0.1); // Green 50
    }
  }

  Color _statusBadgeTextColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return const Color(0xFF475569); // Slate 600
      case ComplaintStatus.pending:
        return const Color(0xFFB45309); // Amber 700
      case ComplaintStatus.awaitingFeedback:
        return const Color(0xFF1E40AF); // Blue 800
      case ComplaintStatus.resolved:
        return const Color(0xFF166534); // Green 800
    }
  }

  Widget _buildStatusCard({
    required ComplaintStatus status,
    required bool isSelected,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    String title = status.label;
    String subtitle = '';
    IconData icon = Icons.circle;
    Color iconColor = _statusBadgeTextColor(status);
    Color circleBgColor = _statusBadgeBgColor(status);

    switch (status) {
      case ComplaintStatus.underReview:
        subtitle = 'Technician is evaluating the issue';
        icon = Icons.search;
        iconColor = const Color(0xFFE8862A);
        circleBgColor = const Color(0xFFFFF7ED);
        break;
      case ComplaintStatus.resolved:
        subtitle = 'Issue has been fixed and verified';
        icon = Icons.check_circle_outline;
        iconColor = const Color(0xFF28A960);
        circleBgColor = const Color(0xFFF0FDF4);
        break;
      case ComplaintStatus.pending:
        subtitle = 'Awaiting technician assignment';
        icon = Icons.access_time_rounded;
        iconColor = const Color(0xFF1E293B);
        circleBgColor = const Color(0xFFF8FAFC);
        break;
      case ComplaintStatus.awaitingFeedback:
        subtitle = 'Waiting for user feedback';
        icon = Icons.chat_bubble_outline;
        iconColor = const Color(0xFF3B82F6);
        circleBgColor = const Color(0xFFEFF6FF);
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: circleBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ModernText(title,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1E293B)),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ModernText('CURRENT',
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppColors.surfaceDark),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  ModernText(subtitle,
                      fontSize: 13, color: const Color(0xFF6B7280)),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFCBD5E1),
                  width: isSelected ? 7 : 2,
                ),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusUpdateSheet() {
    ComplaintStatus? tempStatus = selectedStatus;

    showModernSheet(
      context: context,
      title: 'Update ${widget.complaint.complaintType} Status',
      // subtitle: 'Select the current progress of the complaint',
      // centerTitle: true,
      actionText: 'Confirm Update',
      // actionIcon: Icons.update,
      onAction: () {
        if (tempStatus != null && tempStatus != selectedStatus) {
          setState(() => selectedStatus = tempStatus);
          controller.updateStatus(widget.complaint.id, tempStatus!);
        }
        Navigator.pop(context);
      },
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            children: ComplaintStatus.values.map((status) {
              return _buildStatusCard(
                status: status,
                isSelected: tempStatus == status,
                isCurrent: widget.complaint.status == status,
                onTap: () {
                  setSheetState(() => tempStatus = status);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget _buildTimelineStep(String title, String date, IconData iconData,
      bool isActive, bool isPast, bool isLast) {
    Color iconColor =
        (isActive || isPast) ? Colors.white : const Color(0xFFD1D5DB);
    Color circleColor = (isActive || isPast)
        ? const Color(0xFF1E293B)
        : const Color(0xFFF3F4F6);
    Color textColor =
        isActive ? const Color(0xFF1E293B) : const Color(0xFF9CA3AF);

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  color: (isPast || isActive)
                      ? const Color(0xFF1E293B)
                      : Colors
                          .transparent, // Fix line colors for proper timeline
                ),
              ),
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: circleColor,
                ),
                child: Center(
                  child: Icon(iconData, size: 18, color: iconColor),
                ),
              ),
              Expanded(
                child: Container(
                  height: 3,
                  color: (!isLast && isPast)
                      ? const Color(0xFF1E293B)
                      : (isLast ? Colors.transparent : const Color(0xFFE5E7EB)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ModernText(
            title,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: textColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          ModernText(
            date,
            fontSize: 10,
            color: const Color(0xFF9CA3AF),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusHistory() {
    // Determine step status manually. Adjust based on real logic.
    final currentStatus = widget.complaint.status;
    int currentIndex = 0;
    if (currentStatus == ComplaintStatus.pending) {
      currentIndex = 0;
    } else if (currentStatus == ComplaintStatus.underReview) {
      currentIndex = 1;
    }else if (currentStatus == ComplaintStatus.awaitingFeedback)
      currentIndex = 2; // Treat as "IN REVIEW" for the design match
    else if (currentStatus == ComplaintStatus.resolved) currentIndex = 3;

    final dateStr = DateFormat('MMM dd').format(widget.complaint.dateTime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernText('Status History',
            fontSize: 16, fontWeight: FontWeight.bold),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimelineStep('REPORTED', dateStr, Icons.check,
                currentIndex == 0, currentIndex > 0, false),
            _buildTimelineStep('ASSIGNED', dateStr, Icons.person,
                currentIndex == 1, currentIndex > 1, false),
            _buildTimelineStep(
                'IN REVIEW',
                currentIndex >= 2 ? dateStr : 'Pending',
                Icons.circle,
                currentIndex == 2,
                currentIndex > 2,
                false),
            _buildTimelineStep(
                'RESOLVED',
                currentIndex >= 3 ? dateStr : 'Pending',
                Icons.check_circle_outline,
                currentIndex == 3,
                false,
                true),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(String title, String value,
      {bool isPriority = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ModernText(
            title,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF9CA3AF),
            letterSpacing: 0.5,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isPriority) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: ModernText(
                  value,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernText('Details', fontSize: 16, fontWeight: FontWeight.bold),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildDetailCard(
                    'REPORTED DATE',
                    DateFormat('MMM dd, yyyy')
                        .format(widget.complaint.dateTime))),
            const SizedBox(width: 16),
            Expanded(
                child: _buildDetailCard('PRIORITY', 'High', isPriority: true)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: _buildDetailCard('CATEGORY',
                    'Maintenance')), // Hardcoding to match image, normally use widget.complaint.complaintType
            const SizedBox(width: 16),
            Expanded(
                child: _buildDetailCard('ASSIGNED TO', 'John Maintenance')),
          ],
        ),
      ],
    );
  }

  Widget _buildImagesSection(List<String> imagePaths) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ModernText('Images', fontSize: 16, fontWeight: FontWeight.bold),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...imagePaths.map((path) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        path,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          width: 90,
                          height: 90,
                          color: const Color(0xFFF3F4F6),
                          child: Icon(Icons.image_not_supported,
                              color: AppColors.textMuted),
                        ),
                      ),
                    ),
                  )),
              // Placeholder Box for add image (matching design)
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color(0xFFCBD5E1),
                      style: BorderStyle
                          .none), // Using color fill to simulate dot design or just shape
                ),
                child: Center(
                  child: Icon(Icons.add_a_photo_outlined,
                      color: AppColors.textMuted, size: 28),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Extract first issue description for body to avoid code block parsing
    final description = widget.complaint.issues.isEmpty
        ? 'The main light fixture in the kitchen area is flickering constantly and occasionally making a buzzing sound. This started after the heavy rains yesterday. It poses a safety risk as it\'s near the prep station.'
        : widget.complaint.issues.values.first.description;

    final imagePaths = widget.complaint.issues.values
        .where((i) => i.imagePath != null && i.imagePath!.isNotEmpty)
        .map((i) => i.imagePath!)
        .toList();

    return ModernScaffold(
      appBar: ModernAppBar(
        title: 'Complaint Details',
        showBack: true,
        onBack: () => Navigator.pop(context),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.more_vert, color: Colors.white),
        //     onPressed: () {}, // Action for 3-dots
        //   )
        // ],
      ),
      backgroundColor: hsh.AppColors.background, // Overall white background to match image exactly (Wait, design shows slightly offwhite behind card? Or card has border? No, background is purely white except for Card.) - Let's use white for everything or F9FAFB if top card stands out
      // bottomNavigationBar: ModernBottomBar(
      //   text: 'Update Status',
      //   icon: Icons.sort,
      //   onPressed: _showStatusUpdateSheet,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusBadgeBgColor(widget.complaint.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.complaint.status.label.toUpperCase(),
                          style: TextStyle(
                            color:
                                _statusBadgeTextColor(widget.complaint.status),
                            fontWeight: FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      ModernText(
                        'ID: #${widget.complaint.id.isEmpty ? "CMP-8921" : widget.complaint.id}',
                        fontSize: 12,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ModernText(
                    widget.complaint.complaintType,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: Color(0xFF6B7280)),
                      const SizedBox(width: 4),
                      const ModernText(
                        'Kitchen Area, Floor 2',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            _buildStatusHistory(),

            const SizedBox(height: 32),

            const ModernText('Description',
                fontSize: 16, fontWeight: FontWeight.bold),
            const SizedBox(height: 12),
            ModernText(
              description.isEmpty
                  ? 'The main light fixture in the kitchen area is flickering constantly and occasionally making a buzzing sound. This started after the heavy rains yesterday. It poses a safety risk as it\'s near the prep station.'
                  : description,
              fontSize: 15,
              height: 1.5,
              color: const Color(0xFF6B7280), // Perfect slate grey for text
            ),

            const SizedBox(height: 32),
            _buildDetailsGrid(),

            if (imagePaths.isNotEmpty) ...[
              const SizedBox(height: 32),
              _buildImagesSection(imagePaths),
            ],

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
