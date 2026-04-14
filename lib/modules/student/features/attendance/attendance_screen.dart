import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/models/attendance_record_model.dart';
import 'package:hsh_app/modules/student/features/attendance/controllers/attendance_controller.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;

class AttendanceScreen extends GetView<AttendanceController> {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtil.responsivePadding(context);
    final verticalSpacing = ResponsiveUtil.verticalSpacing(context);

    return ui.ModernScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ui.ModernText(
                    'Select Attendance Type',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D3557),
                  ),
                  // SizedBox(height: 10),
                  _buildAttendanceGrid(),
                  SizedBox(height: verticalSpacing * 2),
                  _buildScanProgressCard(context),
                  const SizedBox(height: 100), // Space for bottom nav
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF1D3557),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ui.ModernText(
            'Hari Saurabh Hostel',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const ui.ModernText(
              'HS',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceGrid() {
    final types = controller.eventConfig.keys.toList();

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemCount: types.length,
      itemBuilder: (context, index) {
        final type = types[index];
        final config = controller.eventConfig[type]!;

        return Obx(() {
          final isSelected = controller.selectedType.value == type;
          return Container(
            decoration: isSelected
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary, width: 2),
                  )
                : null,
            child: ui.ModernStatCard(
              layout: ui.StatCardLayout.iconTop,
              title: type == AttendanceEventType.nightAttendance
                  ? "Night Attd."
                  : type.displayName,
              iconSize: 22,
              iconBgSize: 44,
              icon: config.$1,
              accentColor: isSelected ? AppColors.primary : config.$2,
              onTap: () => controller.selectType(type),
            ),
          );
        });
      },
    );
  }

  Widget _buildScanProgressCard(BuildContext context) {
    return ui.ModernCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ui.ModernText(
                  'Scan Progress',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
                Obx(() => ui.ModernBadge(
                      text: '${controller.scanCount.value}/2 scans',
                      type: ui.BadgeType.info,
                    )),
              ],
            ),
            const SizedBox(height: 24),
            Obx(() => _buildTimelineItem(
                  title: "First Scan",
                  status:
                      controller.scanCount.value >= 1 ? "Completed" : "Pending",
                  isCompleted: controller.scanCount.value >= 1,
                  isLast: false,
                )),
            Obx(() => _buildTimelineItem(
                  title: "Second Scan",
                  status:
                      controller.scanCount.value >= 2 ? "Completed" : "Confirm",
                  isCompleted: controller.scanCount.value >= 2,
                  isLast: true,
                )),
            const SizedBox(height: 30),
            ui.ModernButton(
              text: "Open Scanner",
              icon: Icons.qr_code_scanner_rounded,
              onPressed: () async {
                final result = await Get.toNamed('/student/attendance/scanner');
                if (result != null) {
                  controller.incrementScan();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String status,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color:
                      isCompleted ? AppColors.primary : const Color(0xFFE9F1F8),
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF5D90B3),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE9F1F8),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ui.ModernText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1D3557),
                ),
                ui.ModernText(
                  status,
                  fontSize: 14,
                  color: const Color(0xFF5D90B3),
                ),
                if (!isLast) const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
