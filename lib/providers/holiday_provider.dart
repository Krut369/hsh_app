import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/holiday_model.dart';

class HolidayListNotifier extends StateNotifier<List<Holiday>> {
  HolidayListNotifier() : super([]);

  void addHoliday(Holiday holiday) {
    state = [...state, holiday];
  }

// Removed updateHoliday
// Removed removeHoliday
}

final holidayListProvider =
StateNotifierProvider<HolidayListNotifier, List<Holiday>>(
      (ref) => HolidayListNotifier(),
);
