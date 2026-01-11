import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note_model.dart';
import '../core/constants/app_text.dart';

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier() : super([
    Note(
      id: '1',
      title: 'Room 302 Maintenance Request',
      body: 'Please check the AC unit in Room 302. It\'s making a rattling noise when turned on high.\n\nAlso, the laundry service for this week:\n- 2 Bedspreads\n- 1 Set of curtains\n\nThanks!',
      category: AppText.roomIssue,
      date: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Note(
      id: '2',
      title: 'Laundry List',
      body: '2 Bedspreads, 1 Set of curtains...',
      category: AppText.laundry,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ]);

  void addNote(Note note) {
    // If note ID exists, update it. Otherwise add new.
    final index = state.indexWhere((n) => n.id == note.id);
    if (index >= 0) {
      state = [
        ...state.sublist(0, index),
        note,
        ...state.sublist(index + 1),
      ];
    } else {
      state = [note, ...state];
    }
  }

  void deleteNote(String id) {
    state = state.where((note) => note.id != id).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  return NotesNotifier();
});
