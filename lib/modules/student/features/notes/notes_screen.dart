import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_editor/note_editor_screen.dart';
import 'package:hsh_app/widgets/custom_app_bar.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesController controller = Get.put(NotesController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      controller.fetchNotes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: CustomAppBar(
        title: _isSearching ? '' : AppText.notes,
        showNotificationIcon: false,
        titleWidget: _isSearching
            ? Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: AppColors.textPrimary),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: AppColors.textSecondary, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            controller.fetchNotes(refresh: true, query: '');
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onChanged: (value) {
                    controller.fetchNotes(refresh: true, query: value);
                  },
                ),
              )
            : null,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: AppColors.white),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _isSearching = false;
                  _searchController.clear();
                  controller.fetchNotes(refresh: true, query: '');
                } else {
                  _isSearching = true;
                }
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 64,
                  color: AppColors.textSecondary.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  'No notes yet',
                  style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap + to create your first note',
                  style: TextStyle(color: AppColors.textSecondary.withOpacity(0.6)),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: controller.notes.length + (controller.hasMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == controller.notes.length) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ));
            }

            final note = controller.notes[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Dismissible(
                key: Key(note.id),
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppColors.successGreen.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.edit_outlined,
                      color: AppColors.white, size: 28),
                ),
                secondaryBackground: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: AppColors.cancelledRed.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: AppColors.white, size: 28),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.startToEnd) {
                    Get.to(() => NoteEditorScreen(noteToEdit: note));
                    return false;
                  } else {
                    return await _confirmDelete(context);
                  }
                },
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    controller.deleteNote(note.id);
                  }
                },
                child: InkWell(
                  onTap: () => Get.to(() => NoteEditorScreen(noteToEdit: note)),
                  child: _buildNoteCard(
                    context,
                    title: note.title,
                    preview: note.body,
                    tag: note.category,
                    date: _formatDate(note.date),
                    isPinned: note.isPinned,
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'notes_checklist_fab',
            mini: true,
            onPressed: () => Get.to(() => const NoteEditorScreen(startInChecklistMode: true)),
            backgroundColor: AppColors.secondary,
            child: const Icon(Icons.checklist, color: AppColors.white, size: 20),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'notes_fab',
            onPressed: () => Get.to(() => const NoteEditorScreen()),
            backgroundColor: AppColors.primary,
            elevation: 4,
            child: const Icon(Icons.add, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
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
            style: TextButton.styleFrom(foregroundColor: AppColors.cancelledRed),
            child: const Text('Delete'),
          ),
        ],
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
    bool isPinned = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Row(
                children: [
                  if (isPinned)
                    const Icon(Icons.push_pin, size: 14, color: AppColors.primary),
                  if (isPinned) const SizedBox(width: 4),
                  Text(
                    date,
                    style: AppFonts.smallText(context).copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title.isNotEmpty ? title : 'Untitled Note',
            style: AppFonts.heading2(context).copyWith(
              fontSize: 17,
              height: 1.3,
              color: AppColors.textPrimary,
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
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                  strong: AppFonts.bodyBold(context).copyWith(color: AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
