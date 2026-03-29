import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/modules/student/features/notes/controllers/notes_controller.dart';
import 'package:hsh_app/modules/student/features/notes/note_components.dart';
import 'markdown_controller.dart';
import 'note_toolbar.dart';
import 'format_bottom_sheet.dart';
import 'note_formatting_logic.dart';
import 'checklist_editor.dart';

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
  late MarkdownSyntaxController _bodyController;
  final FocusNode _bodyFocusNode = FocusNode();
  TextSelection _lastSelection = const TextSelection.collapsed(offset: 0);
  TextEditingValue? _lastValue;
  
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
      _bodyController = MarkdownSyntaxController(text: note.body);
      
      // Auto-detect checklist mode if body contains checkboxes
      if (note.body.contains('- [ ]') || note.body.contains('- [x]')) {
        _isChecklistMode = true;
        _parseMarkdownToChecklist(note.body);
      }
    } else {
      _bodyController = MarkdownSyntaxController();
      if (widget.startInChecklistMode) {
        _isChecklistMode = true;
        _parseMarkdownToChecklist('');
      }
    }
    
    _bodyController.addListener(() {
      final newValue = _bodyController.value;
      if (_lastValue != null && newValue != _lastValue) {
          final formattedValue = NoteFormattingLogic.processAutoFormatting(_lastValue!, newValue);
          if (formattedValue != newValue) {
              _bodyController.value = formattedValue;
          }
      }
      _lastValue = _bodyController.value;

      if (_bodyFocusNode.hasFocus && _bodyController.selection.isValid) {
        _lastSelection = _bodyController.selection;
      }
    });
  }

  void _parseMarkdownToChecklist(String text) {
    if (text.trim().isEmpty) {
      _checklistItems = [ChecklistItem(id: const Uuid().v4(), text: '', isDone: false)];
      return;
    }
    final lines = text.split('\n');
    _checklistItems = lines.map((line) {
      final trimmed = line.trim();
      bool isDone = trimmed.startsWith('- [x]');
      String itemText = trimmed.replaceFirst(RegExp(r'^- \[(x| )\]'), '').trim();
      return ChecklistItem(id: const Uuid().v4(), text: itemText, isDone: isDone);
    }).toList();
  }

  void _syncChecklistToMarkdown() {
    final markdown = _checklistItems.map((item) {
      return '- [${item.isDone ? 'x' : ' '}] ${item.text}';
    }).join('\n');
    _bodyController.text = markdown;
  }

  void _toggleChecklistMode() {
    setState(() {
      if (!_isChecklistMode) {
        _isChecklistMode = true;
        _parseMarkdownToChecklist(_bodyController.text);
      } else {
        _isChecklistMode = false;
        _syncChecklistToMarkdown();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _bodyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary), 
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isChecklistMode ? Icons.notes : Icons.checklist,
              color: AppColors.primary,
            ),
            onPressed: _toggleChecklistMode,
            tooltip: _isChecklistMode ? 'Switch to Text' : 'Switch to Checklist',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: TextButton(
              onPressed: () => _saveNote(),
              child: Text(
                AppText.save,
                style: AppFonts.buttonText(context).copyWith(
                  color: AppColors.primary, 
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTag(AppText.roomIssue),
                const SizedBox(width: 8),
                _buildTag(AppText.laundry),
                const SizedBox(width: 8),
                _buildTag(AppText.mealPreference),
                const SizedBox(width: 8),
                _buildTag(AppText.personal),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!_isChecklistMode) _bodyFocusNode.requestFocus();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    TextField(
                      controller: _titleController,
                      style: AppFonts.heading1(context).copyWith(
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        hintText: AppText.noteTitleHint,
                        hintStyle: TextStyle(color: AppColors.requestedGrey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _isChecklistMode
                          ? ChecklistEditor(
                              items: _checklistItems,
                              onChanged: (newItems) => _checklistItems = newItems,
                            )
                          : TextField(
                              focusNode: _bodyFocusNode,
                              controller: _bodyController,
                              maxLines: null,
                              expands: true,
                              style: AppFonts.bodyRegular(context).copyWith(
                                fontSize: 17,
                                height: 1.5,
                                color: AppColors.textPrimary,
                              ),
                              decoration: const InputDecoration(
                                hintText: AppText.noteBodyHint,
                                hintStyle: TextStyle(color: AppColors.requestedGrey),
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                    ),
                  ],
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
    Get.bottomSheet(
      FormatBottomSheet(
        onFormat: (type) {
          _handleFormat(type);
        },
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
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
    if (_isChecklistMode) {
      _syncChecklistToMarkdown();
    }
    
    if (_titleController.text.trim().isEmpty && _bodyController.text.trim().isEmpty) {
        Get.back();
        return;
    }

    String title = _titleController.text;
    if (title.isEmpty) title = "New Note";

    final note = Note(
      id: _isEditing ? widget.noteToEdit!.id : const Uuid().v4(),
      title: title,
      body: _bodyController.text,
      category: _selectedTag,
      isPinned: widget.noteToEdit?.isPinned ?? false,
      date: DateTime.now(),
    );

    if (_isEditing) {
      await controller.updateNote(note);
    } else {
      await controller.addNote(note);
    }

    Get.back();
  }

  void _handleFormat(String type) {
    if (type == 'checkbox') {
      _toggleChecklistMode();
      return;
    }

    if (!_bodyFocusNode.hasFocus) _bodyFocusNode.requestFocus();

    final newValue = NoteFormattingLogic.applyFormat(
      type, 
      _bodyController.value, 
      fallbackSelection: _lastSelection
    );
    _bodyController.value = newValue;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_bodyFocusNode.hasFocus) _bodyFocusNode.requestFocus();
    });
  }
}
