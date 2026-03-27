import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_components.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';

class HolidayScreen extends ConsumerWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidays = ref.watch(holidayListProvider);
    final theme = Theme.of(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: const CustomAppBar(
        title: AppText.holiday,
        showNotificationIcon: true, 
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'holiday_fab',
        onPressed: () => Get.toNamed('/student/holiday/add'),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: holidays.isEmpty
          ? const HolidayEmptyState()
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(padding, padding, padding, padding + 80),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                return HolidayListTile(holiday: holiday);
              },
            ),
    );
  }
}
