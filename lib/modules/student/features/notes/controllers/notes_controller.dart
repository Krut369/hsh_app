import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/services/service_provider.dart';
import 'package:intl/intl.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';
// import 'package:scroll_controller/scroll_controller.dart'

class NotesController extends GetxController {
  final notes = <Note>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final isSearching = false.obs;

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  int _currentPage = 1;
  String _currentQuery = '';
  String _currentCategory = '';

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchNotes(refresh: true);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      fetchNotes();
    }
  }

  void onSearchChanged(String value) {
    fetchNotes(refresh: true, query: value);
  }

  void clearSearch() {
    searchController.clear();
    fetchNotes(refresh: true, query: '');
  }

  void toggleSearch() {
    if (isSearching.value) {
      isSearching.value = false;
      clearSearch();
      return;
    }

    isSearching.value = true;
  }

  Future<bool?> confirmDelete(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String getPreviewText(String body) {
    try {
      final json = jsonDecode(body);
      if (json is Map && json.containsKey('document')) {
        final Map document = json['document'];
        final List children = document['children'] ?? [];
        String preview = '';
        for (final child in children) {
          if (child is Map && child['type'] == 'paragraph') {
            final List delta = child['data']?['delta'] ?? [];
            for (final segment in delta) {
              if (segment is Map && segment.containsKey('insert')) {
                preview += segment['insert'].toString();
              }
            }
          }
          if (preview.length > 150) break;
          preview += ' ';
        }
        return preview.trim();
      }
    } catch (_) {
      return body
          .replaceAll(RegExp(r'#+\s*'), '')
          .replaceAll(RegExp(r'-\s\[(x|\s)\]\s'), '')
          .trim();
    }
    return body.trim();
  }

  String formatModifiedDate(Note note) {
    return DateFormat('MMM d').format(note.updatedAt ?? note.date);
  }

  IconData getCategoryIcon(String tag) {
    switch (tag.toLowerCase()) {
      case 'strategy':
        return Icons.trending_up;
      case 'design':
        return Icons.palette_outlined;
      case 'systems':
        return Icons.star_border_rounded;
      case 'personal':
        return Icons.access_time_rounded;
      default:
        return Icons.notes_rounded;
    }
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
