import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/providers/holiday_provider.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/widgets/custom_button.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_form.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_components.dart';

class HolidayScreen extends ConsumerWidget {
  const HolidayScreen({super.key});

  void _navigateToHolidayForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HolidayForm()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidays = ref.watch(holidayListProvider);
    final theme = Theme.of(context);
    final padding = ResponsiveUtil.responsivePadding(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: padding + 70), // Leave space for button
            child: holidays.isEmpty
                ? const HolidayEmptyState()
                : ListView.builder(
              padding: EdgeInsets.all(padding),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                return HolidayListTile(holiday: holiday);
              },
            ),
          ),
          Positioned(
            left: padding,
            right: padding,
            bottom: padding,
            child: CustomButton(
              text: AppText.requestHoliday,
              onPressed: () => _navigateToHolidayForm(context),
              backgroundColor: theme.colorScheme.primary,
              borderRadius: 15.0,
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ],
      ),
    );
  }
}
