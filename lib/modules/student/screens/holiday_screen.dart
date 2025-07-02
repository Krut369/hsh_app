import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/holiday_model.dart';
import '../../../providers/holiday_provider.dart';
import '../widgets/holiday_form.dart';
import '../../../widgets/custom_button.dart';

class HolidayScreen extends ConsumerWidget {
  const HolidayScreen({super.key});

  void _navigateToHolidayForm(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HolidayForm()),
    );
  }

  Color _getStatusColor(BuildContext context, HolidayStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case HolidayStatus.pending:
        return Colors.orange;
      case HolidayStatus.confirmed:
        return colorScheme.secondary;
      case HolidayStatus.rejected:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final holidays = ref.watch(holidayListProvider);
    final theme = Theme.of(context);
    const padding = 16.0;

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: padding + 70), // Leave space for button
            child: holidays.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.beach_access, size: 80, color: theme.colorScheme.surface.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text(
                    'No holidays requested yet!',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the button below to request a holiday.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: holidays.length,
              itemBuilder: (context, index) {
                final holiday = holidays[index];
                final statusColor = _getStatusColor(context, holiday.status);

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.flight_takeoff,
                            color: theme.colorScheme.primary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                holiday.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'From: ${DateFormat('MMM dd, yyyy').format(holiday.startDate)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                'To: ${DateFormat('MMM dd, yyyy').format(holiday.endDate)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  holiday.status.name.toUpperCase(),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: padding,
            right: padding,
            bottom: padding,
            child: CustomButton(
              text: 'Request Holiday',
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
