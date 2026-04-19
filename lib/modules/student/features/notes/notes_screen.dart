import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_editor/note_editor_screen.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;

class NotesScreen extends GetView<NotesController> {
  const NotesScreen({super.key});

  @override
  NotesController get controller => Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return ui.ModernScaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Obx(
          () => ui.ModernAppBar(
            title: controller.isSearching.value ? '' : 'My Notes',
            actions: [
              if (controller.isSearching.value)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: controller.searchController,
                      builder: (context, value, _) {
                        return TextField(
                          controller: controller.searchController,
                          autofocus: true,
                          style: const TextStyle(color: AppColors.textPrimary),
                          cursorColor: AppColors.primary,
                          decoration: InputDecoration(
                            hintText: 'Search notes...',
                            hintStyle: TextStyle(
                              color: AppColors.textSecondary.withValues(alpha: 0.5),
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.textSecondary,
                            ),
                            suffixIcon: value.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear,
                                      color: AppColors.textSecondary,
                                      size: 20,
                                    ),
                                    onPressed: controller.clearSearch,
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          ),
                          onChanged: controller.onSearchChanged,
                        );
                      },
                    ),
                  ),
                ),
              IconButton(
                icon: Icon(
                  controller.isSearching.value ? Icons.close : Icons.search,
                  color: Colors.white,
                ),
                onPressed: controller.toggleSearch,
              ),
            ],
          ),
        ),
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
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 80,
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      Transform.translate(
                        offset: const Offset(20, 20),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 40,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const ui.ModernText(
                  'No notes yet',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ui.ModernText(
                    'Tap + to create your first note and start capturing your thoughts.',
                    textAlign: TextAlign.center,
                    fontSize: 16,
                    color: AppColors.textSecondary.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ui.ModernText(
                    'Recent Notes',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headerBlue,
                  ),
                  ui.ModernText(
                    DateFormat('MMMM yyyy')
                        .format(DateTime.now())
                        .toUpperCase(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    color: AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                controller: controller.scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: controller.notes.length +
                    (controller.hasMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.notes.length) {
                    return const Center(
                        child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
                  }

                  final note = controller.notes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Dismissible(
                      key: Key(note.id),
                      background: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.edit_outlined,
                            color: Colors.white, size: 28),
                      ),
                      secondaryBackground: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color:
                              AppColors.cancelledRed.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete_outline,
                            color: Colors.white, size: 28),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.startToEnd) {
                          Get.to(() => NoteEditorScreen(noteToEdit: note));
                          return false;
                        } else {
                          return controller.confirmDelete(context);
                        }
                      },
                      onDismissed: (direction) {
                        if (direction == DismissDirection.endToStart) {
                          controller.deleteNote(note.id);
                        }
                      },
                      child: InkWell(
                        onTap: () =>
                            Get.to(() => NoteEditorScreen(noteToEdit: note)),
                        child: _buildNoteCard(
                          context,
                          title: note.title,
                          preview: note.body,
                          tag: note.category,
                          date: DateFormat('MMM d').format(note.date),
                          modifiedDate: controller.formatModifiedDate(note),
                          isPinned: note.isPinned,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        margin: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          heroTag: 'notes_fab',
          onPressed: () => Get.to(() => const NoteEditorScreen()),
          backgroundColor: AppColors.headerBlue,
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: const Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }

  Widget _buildNoteCard(
    BuildContext context, {
    required String title,
    required String preview,
    required String tag,
    required String date,
    required String modifiedDate,
    bool isPinned = false,
  }) {
    final String cleanPreview = controller.getPreviewText(preview);

    return ui.ModernCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ui.ModernText(
                  title.isNotEmpty ? title : 'Untitled Note',
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headerBlue,
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 12),
              ui.ModernBadge(
                text: tag.toUpperCase(),
                type: ui.BadgeType.info,
              ),
            ],
          ),
          const SizedBox(height: 12),
          ui.ModernText(
            cleanPreview,
            fontSize: 15,
            color: AppColors.textSecondary.withValues(alpha: 0.8),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ui.ModernText(
                    'CREATED: $date'.toUpperCase(),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 2),
                  ui.ModernText(
                    'MODIFIED: $modifiedDate'.toUpperCase(),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                ],
              ),
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Icon(
                  controller.getCategoryIcon(tag),
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

