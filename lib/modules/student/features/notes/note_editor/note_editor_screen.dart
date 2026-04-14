import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;
import 'package:uuid/uuid.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_components.dart';
import 'package:hsh_app/widgets/premium_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'dart:convert';
import 'note_toolbar.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? noteToEdit;
  final bool startInChecklistMode;
  const NoteEditorScreen(
      {super.key, this.noteToEdit, this.startInChecklistMode = false});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final NotesController controller = Get.find<NotesController>();
  String _selectedTag = AppText.personal;
  final TextEditingController _titleController = TextEditingController();
  late EditorState _editorState;
  final FocusNode _bodyFocusNode = FocusNode();
  Selection? _lastSelection;

  late bool _isChecklistMode;

  bool get _isEditing => widget.noteToEdit != null;

  @override
  void initState() {
    super.initState();
    _isChecklistMode = widget.startInChecklistMode;

    if (_isEditing) {
      final note = widget.noteToEdit!;
      _titleController.text = note.title;
      _selectedTag = note.category;

      try {
        final json = jsonDecode(note.body);
        _editorState = EditorState(document: Document.fromJson(json));
      } catch (e) {
        // Fallback for legacy plain-text/markdown notes
        final document = Document.fromJson({
          'document': {
            'type': 'page',
            'children': [
              {
                'type': 'paragraph',
                'data': {
                  'delta': note.body.isNotEmpty
                      ? [{'insert': note.body}]
                      : [],
                },
              },
            ],
          },
        });
        _editorState = EditorState(document: document);
      }
    } else {
      // Initialize with a document containing a single empty paragraph
      _editorState = EditorState(
        document: Document.fromJson({
          'document': {
            'type': 'page',
            'children': [
              {
                'type': 'paragraph',
                'data': {
                  'delta': [],
                },
              },
            ],
          },
        }),
      );
    }

    _editorState.selectionNotifier.addListener(_cacheSelection);
  }

  @override
  void dispose() {
    _editorState.selectionNotifier.removeListener(_cacheSelection);
    _titleController.dispose();
    _editorState.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PremiumAppBar(
        height: 75,
        leading: BackButton(color: AppColors.white,),
        title: _isEditing ? 'Edit Story' : 'New Story',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () => _saveNote(),
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final isSaving = UIController.to.isLoading;

        return Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Text(
                    DateFormat('MMMM d, yyyy')
                        .format(widget.noteToEdit?.date ?? DateTime.now())
                        .toUpperCase(),
                    style: TextStyle(
                      color: AppColors.pendingBlue.withValues(alpha: 0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: TextField(
                    controller: _titleController,
                    autofocus: !_isEditing,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.headerBlue,
                      height: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Project Title...',
                      hintStyle:
                          TextStyle(color: AppColors.headerBlue.withValues(alpha: 0.2)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (!_isChecklistMode)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      children: [
                        _buildTag(AppText.roomIssue),
                        const SizedBox(width: 8),
                        _buildTag(AppText.laundry),
                        const SizedBox(width: 8),
                        _buildTag(AppText.mealPreference),
                        const SizedBox(width: 8),
                        _buildTag(AppText.personal),
                        const SizedBox(width: 8),
                        _buildTag('STRATEGY'),
                        const SizedBox(width: 8),
                        _buildTag('DESIGN'),
                      ],
                    ),
                  ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _bodyFocusNode.requestFocus();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: AppFlowyEditor(
                        editorState: _editorState,
                        focusNode: _bodyFocusNode,
                        editorStyle: EditorStyle(
                          padding: EdgeInsets.zero,
                          cursorColor: AppColors.primary,
                          dragHandleColor: AppColors.primary.withValues(alpha: 0.5),
                          selectionColor: AppColors.primary.withValues(alpha: 0.2),
                          textStyleConfiguration: const TextStyleConfiguration(
                            text: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontFamily: 'Roboto',
                            ),
                            lineHeight: 1.5,
                          ),
                          textSpanDecorator: (context, node, index, textInsert,
                              textSpan, decoratedTextSpan) {
                            return decoratedTextSpan;
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (!_isChecklistMode)
                  NoteToolbar(
                    onFormat: _handleFormat,
                    onOpenFormatSheet: _showFormatSheet,
                  ),
              ],
            ),
            if (isSaving) const Positioned.fill(child: ModernOverlayLoader()),
          ],
        );
      }),
    );
  }

  void _showFormatSheet() {
    // Custom logic to show more options if needed
  }

  void _cacheSelection() {
    final selection = _editorState.selection;
    if (selection != null) {
      _lastSelection = selection;
    }
  }

  Widget _buildTag(String label) {
    return NoteTag(
      label: label,
      isSelected: _selectedTag == label,
      onTap: () {
        setState(() {
          _selectedTag = label;
        });
      },
    );
  }

  Future<void> _saveNote() async {
    UIController.to.showLoading();
    try {
      final title = _titleController.text.trim().isEmpty
          ? "New Note"
          : _titleController.text;
      final bodyJson = jsonEncode(_editorState.document.toJson());

      final note = Note(
        id: _isEditing ? widget.noteToEdit!.id : const Uuid().v4(),
        title: title,
        body: bodyJson,
        category: _selectedTag,
        isPinned: widget.noteToEdit?.isPinned ?? false,
        date: widget.noteToEdit?.date ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      if (_isEditing) {
        await controller.updateNote(note);
      } else {
        await controller.addNote(note);
      }

      Get.back();
    } catch (e) {
      UIController.to.showError('Failed to save note: $e');
    } finally {
      UIController.to.hideLoading();
    }
  }

  Future<void> _handleFormat(String type) async {
    final selection = _editorState.selection ?? _lastSelection;
    if (selection == null) return;

    _editorState.selection = selection;
    _bodyFocusNode.requestFocus();

    switch (type) {
      case 'bold':
        await _editorState.toggleAttribute(
          AppFlowyRichTextKeys.bold,
          selection: selection,
          selectionExtraInfo: {
            selectionExtraInfoDoNotAttachTextService: true,
          },
        );
        break;
      case 'italic':
        await _editorState.toggleAttribute(
          AppFlowyRichTextKeys.italic,
          selection: selection,
          selectionExtraInfo: {
            selectionExtraInfoDoNotAttachTextService: true,
          },
        );
        break;
      case 'underline':
        await _editorState.toggleAttribute(
          AppFlowyRichTextKeys.underline,
          selection: selection,
          selectionExtraInfo: {
            selectionExtraInfoDoNotAttachTextService: true,
          },
        );
        break;
      case 'bullet':
        final nodes = _editorState.getNodesInSelection(selection);
        final transaction = _editorState.transaction;
        for (final node in nodes) {
          final isBullet = node.type == BulletedListBlockKeys.type;
          final newType =
              isBullet ? ParagraphBlockKeys.type : BulletedListBlockKeys.type;
          transaction.insertNode(
            node.path,
            node.copyWith(type: newType),
          );
          transaction.deleteNode(node);
        }
        await _editorState.apply(transaction);
        break;
    }
  }
}
