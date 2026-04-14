import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_components.dart';
import 'package:hsh_app/widgets/premium_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'dart:convert';
import 'note_toolbar.dart';
import 'format_bottom_sheet.dart';

class NoteEditorScreen extends StatefulWidget {
  final Note? noteToEdit;
  final bool startInChecklistMode;
  const NoteEditorScreen({super.key, this.noteToEdit, this.startInChecklistMode = false});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final NotesController controller = Get.find<NotesController>();
  String _selectedTag = AppText.personal;
  final TextEditingController _titleController = TextEditingController();
  late EditorState _editorState;
  final FocusNode _bodyFocusNode = FocusNode();
  
  bool _isChecklistMode = false;
  List<ChecklistItem> _checklistItems = [];
  
  bool get _isEditing => widget.noteToEdit != null;

  @override
  void initState() {
    super.initState();
    
    if (_isEditing) {
      final note = widget.noteToEdit!;
      _titleController.text = note.title;
      _selectedTag = note.category;
      
      try {
        final json = jsonDecode(note.body);
        _editorState = EditorState(document: Document.fromJson(json));
      } catch (e) {
        // Fallback for legacy markdown notes
        _editorState = EditorState.blank(withInitialText: true);
        if (note.body.isNotEmpty) {
           _editorState.update(
            _editorState.transaction()
              ..insertText(
                _editorState.document.root,
                0,
                note.body,
              ),
          );
        }
      }
    } else {
      _editorState = EditorState.blank(withInitialText: true);
    }
  }

  @override
  void dispose() {
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(
              DateFormat('MMMM d, yyyy').format(widget.noteToEdit?.date ?? DateTime.now()).toUpperCase(),
              style: TextStyle(
                color: AppColors.pendingBlue.withOpacity(0.5),
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                hintStyle: TextStyle(color: AppColors.headerBlue.withOpacity(0.2)),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),

          if (!_isChecklistMode)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
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
                    cursorColor: AppColors.primary,
                    padding: EdgeInsets.zero,
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
    );
  }

  void _showFormatSheet() {
    // Custom logic to show more options if needed
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
    final title = _titleController.text.trim().isEmpty ? "New Note" : _titleController.text;
    final bodyJson = jsonEncode(_editorState.document.toJson());

    final note = Note(
      id: _isEditing ? widget.noteToEdit!.id : const Uuid().v4(),
      title: title,
      body: bodyJson,
      category: _selectedTag,
      isPinned: widget.noteToEdit?.isPinned ?? false,
      date: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    if (_isEditing) {
      await controller.updateNote(note);
    } else {
      await controller.addNote(note);
    }

    Get.back();
  }

  void _handleFormat(String type) {
    if (_editorState.selection == null) return;

    switch (type) {
      case 'bold':
        _editorState.toggleAttribute(AppFlowyRichTextKeys.bold);
        break;
      case 'italic':
        _editorState.toggleAttribute(AppFlowyRichTextKeys.italic);
        break;
      case 'bullet':
        final selection = _editorState.selection;
        if (selection != null) {
          final nodes = _editorState.getNodesInSelection(selection);
          final transaction = _editorState.transaction;
          for (final node in nodes) {
            transaction.updateNode(node, {
              'type': BulletedListBlockKeys.type,
            });
          }
          _editorState.apply(transaction);
        }
        break;
    }
  }
}
