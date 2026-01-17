import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/leave_request_model.dart';


class HolidayListNotifier extends StateNotifier<List<LeaveRequest>> {
  HolidayListNotifier() : super([]);

  void addHoliday(LeaveRequest request) {
    state = [...state, request];
  }
}

final holidayListProvider =
    StateNotifierProvider<HolidayListNotifier, List<LeaveRequest>>(
  (ref) {
    // Initialize with some dummy data for demonstration if needed, 
    // or keep empty. Using empty as per original.
    // However, to make it realistic, we could fetch existing ones. 
    // For now, keeping it simple as before.
    return HolidayListNotifier();
  },
);
