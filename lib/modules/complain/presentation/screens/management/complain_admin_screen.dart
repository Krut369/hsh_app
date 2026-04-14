import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uitoolkit/uitoolkit.dart';
import 'package:hsh_app/core/theme/app_colors.dart' as hsh;
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'complaint_detail_view_screen.dart';

class ComplaintAdminScreen extends StatefulWidget {
  final String? initialCategory;
  
  const ComplaintAdminScreen({super.key, this.initialCategory});

  @override
  State<ComplaintAdminScreen> createState() => _ComplaintAdminScreenState();
}

class _ComplaintAdminScreenState extends State<ComplaintAdminScreen> {
  final ComplainController controller = Get.find<ComplainController>();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns the accent color for the left card border based on status.
  Color _statusAccentColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return const Color(0xFFE8862A); // Orange
      case ComplaintStatus.resolved:
        return const Color(0xFF28A960); // Green
      case ComplaintStatus.pending:
        return const Color(0xFF2B3A4E); // Dark teal/navy
      case ComplaintStatus.awaitingFeedback:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  /// Returns the badge background color for the status pill.
  Color _statusBadgeColor(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return const Color(0xFFE8862A);
      case ComplaintStatus.resolved:
        return const Color(0xFF28A960);
      case ComplaintStatus.pending:
        return const Color(0xFF2B3A4E);
      case ComplaintStatus.awaitingFeedback:
        return const Color(0xFF3B82F6);
    }
  }

  /// Returns the display label for the status badge (uppercase).
  String _statusBadgeLabel(ComplaintStatus status) {
    switch (status) {
      case ComplaintStatus.underReview:
        return 'UNDER REVIEW';
      case ComplaintStatus.resolved:
        return 'RESOLVED';
      case ComplaintStatus.pending:
        return 'PENDING';
      case ComplaintStatus.awaitingFeedback:
        return 'AWAITING';
    }
  }

  /// Builds the first description line from the issues map.
  String _descriptionText(Complaint complaint) {
    if (complaint.issues.isEmpty) return '';
    final first = complaint.issues.values.first;
    return first.description;
  }

  /// Builds a formatted complaint ID string.
  String _complaintIdStr(Complaint complaint) {
    final id = complaint.id;
    if (id.isEmpty) return '#CMP';
    return '#CMP${id.padLeft(8, '0')}';
  }

  /// Location / sub-complaint hint from the first issue key.
  String _locationText(Complaint complaint) {
    if (complaint.issues.isEmpty) return '';
    return complaint.issues.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      backgroundColor: const Color(0xFFF1F6F9),
      appBar: ModernAppBar(
        title: widget.initialCategory != null ? (widget.initialCategory == 'All Complaints' ? 'All Complaints' : '${widget.initialCategory} Complaints') : 'Complaint Management',
        onSearchPressed: widget.initialCategory != null ? () {
          setState(() {
            _isSearchVisible = !_isSearchVisible;
            if (!_isSearchVisible) _searchController.clear();
          });
        } : null,
        onFilterPressed: widget.initialCategory != null ? () => _showFilterSheet(context) : null,
      ),
      body: Obx(() {
        // Ensure GetX registers changes by accessing observables synchronously.
        // This prevents the "improper use of GetX" error when the only observable
        // accesses were inside the lazy GridView/ListView builders.
        // ignore: unused_local_variable
        final isLoadingObx = controller.isLoading.value;
        // ignore: unused_local_variable
        final complaintsLenObx = controller.complaints.length;
        
        final content = <Widget>[];

        if (_isSearchVisible) {
          content.add(
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ModernSearchField(
                  hint: 'Search by ID, type, or description...',
                  onChanged: (val) => setState(() {}),
                  controller: _searchController,
                  onFilterPressed: () => _showFilterSheet(context),
                ),
              ),
            ),
          );
        }

        // --- Compact Category Grid ---
        if (widget.initialCategory == null) {
          content.add(
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     const ModernText(
                    //       'Categories',
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.bold,
                    //       isSecondary: true,
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: complaintTypes.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                            return _CategoryCard(
                              name: 'All Complaints',
                              count: controller.complaints.length,
                              onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ComplaintAdminScreen(initialCategory: 'All Complaints'),
                                ),
                              );
                            },
                          );
                        }

                        final type = complaintTypes[index - 1];
                        final count = controller.categoryCounts[type.name] ?? 0;

                        return _CategoryCard(
                          name: type.name,
                          count: count,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ComplaintAdminScreen(initialCategory: type.name),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (widget.initialCategory != null || _searchController.text.isNotEmpty) {
          if (controller.isLoading.value && controller.complaints.isEmpty) {
            content.add(const SliverFillRemaining(child: Center(child: ModernLoader())));
          } else if (controller.error.value != null) {
            content.add(
              SliverFillRemaining(
                child: Center(
                  child: Text(
                    'Error loading complaints:\n${controller.error.value}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
            );
          } else {
            final searchQuery = _searchController.text.toLowerCase();
            final list = controller.filteredComplaints.where((complaint) {
              if (widget.initialCategory != null && widget.initialCategory != 'All Complaints' && complaint.complaintType != widget.initialCategory) {
                return false;
              }
              if (searchQuery.isEmpty) return true;
              final idStr = _complaintIdStr(complaint).toLowerCase();
              final type = complaint.complaintType.toLowerCase();
              final desc = _descriptionText(complaint).toLowerCase();
              final location = _locationText(complaint).toLowerCase();
              return idStr.contains(searchQuery) ||
                  type.contains(searchQuery) ||
                  desc.contains(searchQuery) ||
                  location.contains(searchQuery);
            }).toList();

            if (list.isEmpty) {
              content.add(
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        ModernText(
                          searchQuery.isNotEmpty
                              ? 'No complaints matching "$searchQuery"'
                              : 'No complaints found',
                          fontSize: 16,
                          color: Colors.grey.shade500,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              content.add(
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildComplaintCard(context, list[index]),
                      childCount: list.length,
                    ),
                  ),
                ),
              );
            }
          }
        }

        return CustomScrollView(
          slivers: content,
        );
      }),
    );
  }

  /// A single complaint card matching the design.
  Widget _buildComplaintCard(BuildContext context, Complaint complaint) {
    final accentColor = _statusAccentColor(complaint.status);
    final badgeColor = _statusBadgeColor(complaint.status);
    final description = _descriptionText(complaint);
    final location = _locationText(complaint);
    final idStr = _complaintIdStr(complaint);
    final dateStr = DateFormat('MMM dd, hh:mm a').format(complaint.dateTime);
    final isResolved = complaint.status == ComplaintStatus.resolved;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: ModernCard(
        padding: EdgeInsets.zero,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ComplaintDetailViewScreen(complaint: complaint),
          ),
        ),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left border
              Container(width: 6, color: accentColor),
              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Row 1: Title + Status badge
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ModernText(
                              complaint.complaintType,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: badgeColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              _statusBadgeLabel(complaint.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Row 2: Complaint ID + location
                      ModernText(
                        location.isNotEmpty ? '$idStr • $location' : idStr,
                        fontSize: 13,
                        isSecondary: true,
                      ),
                      const SizedBox(height: 12),

                      // Row 3: Description
                      if (description.isNotEmpty)
                        ModernText(
                          description,
                          fontSize: 14,
                          color: const Color(0xFF4B5563),
                          height: 1.45,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      // Divider
                      const SizedBox(height: 16),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.grey.shade200,
                      ),
                      const SizedBox(height: 16),

                      // Row 4: Date + Action button
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 15, color: Colors.grey.shade500),
                          const SizedBox(width: 5),
                          ModernText(
                            dateStr,
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                          const Spacer(),
                          _buildActionButton(context, complaint, isResolved),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  /// Builds the action button at the bottom-right of each card.
  Widget _buildActionButton(
      BuildContext context, Complaint complaint, bool isResolved) {
    if (isResolved) {
      // Green outlined "Finished" chip
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF28A960), width: 1.5),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 16, color: Color(0xFF28A960)),
            SizedBox(width: 4),
            Text(
              'Finished',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF28A960),
              ),
            ),
          ],
        ),
      );
    }

    // Dark pill button for Update Status / Accept
    final label = complaint.status == ComplaintStatus.pending
        ? 'Accept'
        : 'Update Status';

    return Material(
      color: const Color(0xFF1E293B),
      borderRadius: BorderRadius.circular(100),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => _showStatusUpdateSheet(context, complaint),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Dialogs ─────────────────────────────────────────────

  Widget _buildStatusCard({
    required ComplaintStatus status,
    required bool isSelected,
    required bool isCurrent,
    required VoidCallback onTap,
  }) {
    String title = status.label;
    String subtitle = '';
    IconData icon = Icons.circle;
    Color iconColor = _statusBadgeColor(status);
    Color circleBgColor = AppColors.warning.withValues(alpha: 0.1);

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
            color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6),
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
                      ModernText(title, fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: ModernText('CURRENT', fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.surfaceDark),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  ModernText(subtitle, fontSize: 13, color: const Color(0xFF6B7280)),
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
                  color: isSelected ? const Color(0xFF1E293B) : const Color(0xFFCBD5E1),
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

  void _showStatusUpdateSheet(BuildContext context, Complaint complaint) {
    ComplaintStatus? selectedStatus = complaint.status;

    showModernSheet(
      context: context,
      title: 'Update ${complaint.complaintType} Status',
      // subtitle: 'Select the current progress of the complaint',
      // centerTitle: true,
      actionText: 'Confirm Update',
      // actionIcon: Icons.update,
      onAction: () {
        if (selectedStatus != null && selectedStatus != complaint.status) {
          controller.updateStatus(complaint.id, selectedStatus!);
        }
        Navigator.pop(context);
      },
      child: StatefulBuilder(
        builder: (ctx, setSheetState) {
          return Column(
            children: ComplaintStatus.values.map((status) {
              return _buildStatusCard(
                status: status,
                isSelected: selectedStatus == status,
                isCurrent: complaint.status == status,
                onTap: () {
                  setSheetState(() => selectedStatus = status);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    ComplaintStatus? tempStatus = controller.filter.value;
    // Assuming you might add a type filter in the controller later
    // String? tempType = controller.typeFilter.value;

    showModernSheet(
      context: context,
      title: 'Filter Complaints',
      clearAllText: 'Reset',
      onClearAll: () {
        controller.setFilter(null);
        // If type filter exists: controller.setTypeFilter(null);
        Navigator.pop(context);
      },
      actionText: 'Apply Filters',
      onAction: () {
        controller.setFilter(tempStatus);
        // If type filter exists: controller.setTypeFilter(tempType);
        Navigator.pop(context);
      },
      child: StatefulBuilder(
        builder: (context, setState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Filter by Status ──
                ModernText(
                  'Filter by Status',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF4B5563),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<ComplaintStatus?>(
                      isExpanded: true,
                      value: tempStatus,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6B7280)),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: ModernText('All Statuses', fontSize: 15),
                        ),
                        ...ComplaintStatus.values.map(
                          (status) => DropdownMenuItem(
                            value: status,
                            child: ModernText(status.label, fontSize: 15),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          tempStatus = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.name,
    required this.count,
    required this.onTap,
  });

  IconData _getIcon() {
    switch (name) {
      case 'All Complaints': return Icons.all_inbox_rounded;
      case 'Carpentry': return Icons.handyman_rounded;
      case 'Electrical': return Icons.bolt_rounded;
      case 'Plumbing': return Icons.plumbing_rounded;
      case 'Housekeeping': return Icons.cleaning_services_rounded;
      case 'Construction': return Icons.foundation_rounded;
      default: return Icons.construction_rounded;
    }
  }

  Color _getIconColor() {
    switch (name) {
      case 'All Complaints': return const Color(0xFF4285F4);
      case 'Carpentry': return const Color(0xFF8E24AA);
      case 'Electrical': return const Color(0xFFE53935);
      case 'Plumbing': return const Color(0xFF039BE5);
      case 'Housekeeping': return const Color(0xFF34A853);
      case 'Construction': return const Color(0xFFF2994A);
      default: return const Color(0xFF7A869A);
    }
  }

  Color _getBgColor() {
    switch (name) {
      case 'All Complaints': return const Color(0xFFE8F0FE);
      case 'Carpentry': return const Color(0xFFF3E5F5);
      case 'Electrical': return const Color(0xFFFFEBEE);
      case 'Plumbing': return const Color(0xFFE1F5FE);
      case 'Housekeeping': return const Color(0xFFE6F4EA);
      case 'Construction': return const Color(0xFFFDF0E3);
      default: return const Color(0xFFF1F5F9);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: _getBgColor(),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A869A),
                          letterSpacing: 0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            count.toString(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1D3557),
                              height: 1.0,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _getBgColor(),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getIcon(),
                              color: _getIconColor(),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
