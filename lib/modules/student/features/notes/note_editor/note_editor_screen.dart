import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/modules/student/features/notes/models/note_model.dart';
import 'package:hsh_app/providers/notes_provider.dart';
import 'package:hsh_app/modules/student/features/notes/note_components.dart';
import 'markdown_controller.dart';
import 'note_toolbar.dart';
import 'format_bottom_sheet.dart';
import 'note_formatting_logic.dart';

class NoteEditorScreen extends ConsumerStatefulWidget {
  final Note? noteToEdit;
  const NoteEditorScreen({super.key, this.noteToEdit});

  @override
  ConsumerState<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends ConsumerState<NoteEditorScreen> {
  String _selectedTag = AppText.roomIssue;
  final TextEditingController _titleController = TextEditingController();
  late MarkdownSyntaxController _bodyController; // Use custom controller
  final FocusNode _bodyFocusNode = FocusNode();
  TextSelection _lastSelection = const TextSelection.collapsed(offset: 0);
  TextEditingValue? _lastValue;
  
  // Track if we are editing
  bool get _isEditing => widget.noteToEdit != null;

  // Auto-save
  Timer? _debounce;
  bool _isSaving = false;
  DateTime? _lastSaved;

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing data if editing
    if (_isSaving) { // Typo in original code check, but keeping logic consistent with cleanup below
       // ... logic handled below
    }

    if (_isEditing) {
      final note = widget.noteToEdit!;
      _titleController.text = note.title;
      _selectedTag = note.category;
      _bodyController = MarkdownSyntaxController(text: note.body);
    } else {
      _bodyController = MarkdownSyntaxController();
    }
    
    // Listeners for auto-save and auto-format
    _titleController.addListener(_onTextChanged);
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
      _onTextChanged();
    });
  }

  void _onTextChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    setState(() {
      _isSaving = true;
    });

    _debounce = Timer(const Duration(seconds: 2), () {
      _saveNote(silent: true);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.primary), 
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                if (_isSaving) 
                  const Text(
                    'Saving...',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  )
                else if (_lastSaved != null)
                  const Text(
                    'Saved',
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _saveNote(silent: false),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                  child: Text(
                    AppText.save,
                    style: AppFonts.buttonText(context).copyWith(
                      color: AppColors.primary, 
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tags Row
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
          const Divider(height: 1),
          
          Expanded(
            child: GestureDetector(
              onTap: () {
                // Tapping background focuses body
                _bodyFocusNode.requestFocus();
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
                      ),
                      decoration: const InputDecoration(
                        hintText: AppText.noteTitleHint,
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: TextField(
                        focusNode: _bodyFocusNode,
                        controller: _bodyController,
                        maxLines: null,
                        expands: true,
                        style: AppFonts.bodyRegular(context).copyWith(
                          fontSize: 17,
                          height: 1.5,
                        ),
                        decoration: const InputDecoration(
                          hintText: AppText.noteBodyHint,
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
          
          // Quick Toolbar
          NoteToolbar(
            onFormat: _handleFormat,
            onOpenFormatSheet: _showFormatSheet,
          ), 
        ],
      ),
    );
  }

  void _showFormatSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FormatBottomSheet(
        onFormat: (type) {
          // Navigator.pop(context); // Optional: Close sheet on selection? 
          // Keeping it open allows multiple edits.
          _handleFormat(type);
        },
      ),
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

  Future<void> _saveNote({bool silent = false}) async {
    if (_titleController.text.trim().isEmpty && _bodyController.text.trim().isEmpty) {
        // Empty note?
        if (!silent) Navigator.pop(context);
        return;
    }

    // Default title if empty
    String title = _titleController.text;
    if (title.isEmpty) {
        title = "New Note";
    }

    final newNote = Note(
      id: _isEditing ? widget.noteToEdit!.id : const Uuid().v4(),
      title: title,
      body: _bodyController.text,
      category: _selectedTag,
      date: DateTime.now(),
    );

    ref.read(notesProvider.notifier).addNote(newNote); // Updates if ID exists

    setState(() {
      _isSaving = false;
      _lastSaved = DateTime.now();
    });

    if (!silent) {
      Navigator.pop(context);
    }
  }

  void _handleFormat(String type) {
    if (!_bodyFocusNode.hasFocus) {
       _bodyFocusNode.requestFocus();
    }

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
