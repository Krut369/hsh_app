import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_editor/note_editor_screen.dart';
import 'package:hsh_app/widgets/premium_app_bar.dart';

class NotesScreen extends GetView<NotesController> {
  const NotesScreen({super.key});

  @override
  NotesController get controller => Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Obx(
          () => PremiumAppBar(
            leading: BackButton(color: AppColors.white),
            title: controller.isSearching.value ? '' : 'My Notes',
            titleWidget: controller.isSearching.value
                ? Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
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
                              color:
                                  AppColors.textSecondary.withValues(alpha: 0.5),
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
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(
                  controller.isSearching.value ? Icons.close : Icons.search,
                  color: AppColors.white,
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
                    color: AppColors.white,
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
                const Text(
                  'No notes yet',
                  style: TextStyle(
                      color: AppColors.headerBlue,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Tap + to create your first note and start capturing your thoughts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 16,
                      height: 1.5,
                    ),
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
                  const Text(
                    'Recent Notes',
                    style: TextStyle(
                      color: AppColors.headerBlue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    DateFormat('MMMM yyyy')
                        .format(DateTime.now())
                        .toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.6),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
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
                            color: AppColors.white, size: 28),
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
                            color: AppColors.white, size: 28),
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
          child: const Icon(Icons.add, color: AppColors.white, size: 30),
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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.isNotEmpty ? title : 'Untitled Note',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.headerBlue,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tag.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.primary.withValues(alpha: 0.7),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            cleanPreview,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CREATED: $date'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'MODIFIED: $modifiedDate'.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.4),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
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
