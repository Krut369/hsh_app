import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_components.dart';

class HolidayScreen extends ConsumerWidget {
  const HolidayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidays = ref.watch(holidayListProvider);
    final theme = Theme.of(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Stack(
        children: [
          holidays.isEmpty
              ? const HolidayEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.fromLTRB(padding, padding, padding, padding + 80),
                  itemCount: holidays.length,
                  itemBuilder: (context, index) {
                    final holiday = holidays[index];
                    return HolidayListTile(holiday: holiday);
                  },
                ),
          Positioned(
            left: padding,
            right: padding,
            bottom: padding,
            child: CustomButton(
              text: AppText.requestHoliday,
              onPressed: () => context.push('/student/holiday/add'),
              backgroundColor: theme.colorScheme.primary,
              borderRadius: 24.0,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
