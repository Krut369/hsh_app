import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/modules/student/features/notes/note_editor/note_editor_screen.dart';
import 'package:hsh_app/providers/notes_provider.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum SortOption { newest, oldest, titleAZ }

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  SortOption _sortOption = SortOption.newest;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesProvider);

    // Filter and Sort Logic
    List<Note> filteredNotes = notes.where((note) {
      final query = _searchQuery.toLowerCase();
      return note.title.toLowerCase().contains(query) ||
          note.body.toLowerCase().contains(query) ||
          note.category.toLowerCase().contains(query);
    }).toList();

    filteredNotes.sort((a, b) {
      switch (_sortOption) {
        case SortOption.newest:
          return b.date.compareTo(a.date);
        case SortOption.oldest:
          return a.date.compareTo(b.date);
        case SortOption.titleAZ:
          return a.title.compareTo(b.title);
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: CustomAppBar(
        title: _isSearching ? '' : AppText.notes,
        showNotificationIcon: false,
        titleWidget: _isSearching
            ? Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.black87),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: Colors.white),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchQuery = '';
                  _searchController.clear();
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
          if (!_isSearching)
            PopupMenuButton<SortOption>(
              icon: const Icon(Icons.sort, color: Colors.white),
              onSelected: (option) {
                setState(() {
                  _sortOption = option;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: SortOption.newest,
                  child: Text('Date (Newest First)'),
                ),
                const PopupMenuItem(
                  value: SortOption.oldest,
                  child: Text('Date (Oldest First)'),
                ),
                const PopupMenuItem(
                  value: SortOption.titleAZ,
                  child: Text('Title (A-Z)'),
                ),
              ],
            ),
        ],
      ),
      body: filteredNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(
                      _searchQuery.isNotEmpty
                          ? Icons.search_off
                          : Icons.note_alt_outlined,
                      size: 64,
                      color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty
                        ? 'No notes found'
                        : 'No notes yet',
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  if (_searchQuery.isEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Tap + to create your first note',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key(note.id),
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.edit_outlined,
                          color: Colors.white, size: 28),
                    ),
                    secondaryBackground: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerRight,
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: Colors.white, size: 28),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                NoteEditorScreen(noteToEdit: note),
                          ),
                        );
                        return false;
                      } else {
                        return true;
                      }
                    },
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        ref.read(notesProvider.notifier).deleteNote(note.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${note.title} deleted')),
                        );
                      }
                    },
                    child: _buildNoteCard(
                      context,
                      title: note.title,
                      preview: note.body,
                      tag: note.category,
                      date: _formatDate(note.date),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'notes_fab',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteEditorScreen()),
          );
        },
        backgroundColor: AppColors.primary,
         elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  String _formatDate(DateTime date) {
    if (date.day == DateTime.now().day &&
        date.month == DateTime.now().month &&
        date.year == DateTime.now().year) {
      return 'Today, ${DateFormat('h:mm a').format(date)}';
    }
    return DateFormat('MMM d, yyyy').format(date);
  }

  Widget _buildNoteCard(BuildContext context, {
    required String title,
    required String preview,
    required String tag,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tag == 'Important'
                      ? Colors.red.withOpacity(0.1)
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    color:
                        tag == 'Important' ? Colors.red : AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                date,
                style: AppFonts.smallText(context).copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title.isNotEmpty ? title : 'Untitled Note',
            style: AppFonts.heading2(context).copyWith(
              fontSize: 17,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 60,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: MarkdownBody(
                data: preview,
                styleSheet: MarkdownStyleSheet(
                  p: AppFonts.bodyRegular(context).copyWith(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  strong: AppFonts.bodyBold(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
