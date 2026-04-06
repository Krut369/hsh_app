import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_components.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;

class HolidayScreen extends ConsumerWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidays = ref.watch(holidayListProvider);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      floatingActionButton: FloatingActionButton(
        heroTag: 'holiday_fab',
        onPressed: () => Get.toNamed('/student/holiday/add'),
        backgroundColor: AppColors.headerBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          // Navy Arc Header
          _buildHeader(context),

          // Content
          Expanded(
            child: holidays.isEmpty
                ? const HolidayEmptyState()
                : RefreshIndicator(
                    onRefresh: () async {
                      // Add refresh logic if needed
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(padding, 20, padding, 50),
                      itemCount: holidays.length,
                      itemBuilder: (context, index) {
                        final holiday = holidays[index];
                        return HolidayListTile(holiday: holiday);
                      },
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
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 24,
        left: 12,
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
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const ModernText(
            "Holiday",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          const Spacer(),
          const Icon(Icons.notifications_none_rounded,
              color: Colors.white, size: 24),
        ],
      ),
    );
  }
}
