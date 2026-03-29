import 'package:get/get.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/services/service_provider.dart';
import 'package:uitoolkit/uitoolkit.dart';

class NotesController extends GetxController {
  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  int _currentPage = 1;
  String _currentQuery = '';
  String _currentCategory = '';

  @override
  void onInit() {
    super.onInit();
    fetchNotes(refresh: true);
  }

  Future<void> fetchNotes({
    bool refresh = false,
    String? query,
    String? category,
  }) async {
    if (refresh) {
      _currentPage = 1;
      hasMore.value = true;
      if (query != null) _currentQuery = query;
      if (category != null) _currentCategory = category;
    } else {
      if (!hasMore.value || isLoadingMore.value) return;
      _currentPage++;
      isLoadingMore.value = true;
    }

    if (refresh) isLoading.value = true;

    try {
      final response = await serviceProvider.notes.getNotes(
        query: _currentQuery,
        category: _currentCategory,
        page: _currentPage,
      );

      if (response.success && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final wrapperData = responseData['data'];

        List<dynamic> dataList = [];
        Map<String, dynamic> meta = {};

        if (wrapperData is Map<String, dynamic>) {
          dataList = wrapperData['data'] ?? [];
          meta = wrapperData['meta'] ?? {};
        } else if (wrapperData is List) {
          dataList = wrapperData;
        }

        final int totalPages = meta['totalPages'] ?? 1;

        final fetchedNotes = dataList
            .map((e) => Note.fromMap(e as Map<String, dynamic>))
            .toList();

        if (refresh) {
          notes.value = fetchedNotes;
        } else {
          notes.addAll(fetchedNotes);
        }

        hasMore.value = _currentPage < totalPages;
      }
    } catch (e) {
      UIController.to.showError('Failed to fetch notes');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> addNote(Note note, {bool silent = false}) async {
    try {
      final response = await serviceProvider.notes.createNote(
        title: note.title,
        body: note.body,
        category: note.category,
        isPinned: note.isPinned,
      );
      if (response.success) {
        if (response.data != null && response.data['data'] != null) {
          notes.insert(0, Note.fromMap(response.data['data']));
        } else {
          notes.insert(0, note);
        }
        if (!silent) UIController.to.showSuccess('Note saved successfully!');
      }
    } catch (e) {
      if (!silent) UIController.to.showError('Failed to create note');
    }
  }

  Future<void> updateNote(Note note, {bool silent = false}) async {
    try {
      final response = await serviceProvider.notes.updateNote(
        noteId: note.id,
        title: note.title,
        body: note.body,
        category: note.category,
        isPinned: note.isPinned,
      );
      if (response.success) {
        final index = notes.indexWhere((n) => n.id == note.id);
        if (index != -1) {
          if (response.data != null && response.data['data'] != null) {
            notes[index] = Note.fromMap(response.data['data']);
          } else {
            notes[index] = note;
          }
        }
        if (!silent) UIController.to.showSuccess('Note updated successfully!');
      }
    } catch (e) {
      if (!silent) UIController.to.showError('Failed to update note');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      final response = await serviceProvider.notes.deleteNote(id);
      if (response.success) {
        notes.removeWhere((n) => n.id == id);
        UIController.to.showSuccess('Note deleted successfully!');
      }
    } catch (e) {
      UIController.to.showError('Failed to delete note');
    }
  }
}
