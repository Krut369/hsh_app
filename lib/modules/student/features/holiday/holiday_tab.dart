import 'package:flutter/material.dart';

import 'package:hsh_app/modules/student/features/holiday/holiday_screen.dart';

class HolidayTab extends StatelessWidget {
  const HolidayTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const HolidayScreen(),
    );
  }
}
