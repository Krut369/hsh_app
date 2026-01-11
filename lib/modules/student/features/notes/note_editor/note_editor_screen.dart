import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/models/note_model.dart';
import 'package:hsh_app/providers/notes_provider.dart';
import 'package:hsh_app/modules/student/features/notes/note_components.dart';
import 'markdown_controller.dart';
import 'note_toolbar.dart';
import 'format_bottom_sheet.dart';

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
    
    // Listeners for auto-save
    _titleController.addListener(_onTextChanged);
    _bodyController.addListener(() {
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.amber), 
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
                    foregroundColor: Colors.amber[700], // Professional accent color
                  ),
                  child: const Text(
                    AppText.save,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
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
                      style: const TextStyle(
                        fontSize: 28, // Larger title
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
                        style: const TextStyle(
                          fontSize: 17, // Standard readable size
                          height: 1.5,
                          color: Colors.black87,
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

    final text = _bodyController.text;
    final selection = _bodyController.selection.isValid && _bodyController.selection.start >= 0
        ? _bodyController.selection 
        : _lastSelection;
    
    final effectiveSelection = selection.start >= 0 && selection.end <= text.length
        ? selection
        : TextSelection.collapsed(offset: text.length);

    final start = effectiveSelection.start;
    final end = effectiveSelection.end;
    
    String newText = text;
    int newSelectionOffset = start;

    switch (type) {
      case 'bold':
        if (start == end) {
          newText = text.replaceRange(start, end, '****');
          newSelectionOffset = start + 2;
        } else {
          final selectedText = text.substring(start, end);
          newText = text.replaceRange(start, end, '**$selectedText**');
          newSelectionOffset = end + 4; 
        }
        break;
      case 'italic':
        if (start == end) {
          newText = text.replaceRange(start, end, '__'); // Using _ since controller supports it
          newSelectionOffset = start + 1;
        } else {
          final selectedText = text.substring(start, end);
          newText = text.replaceRange(start, end, '_${selectedText}_');
          newSelectionOffset = end + 2;
        }
        break;
      case 'list':
        // If start is at beginning of line or empty, add '- '
        // Ideally checking for newline logic, but stick to simple for now
        newText = text.replaceRange(start, end, '\n- ');
        newSelectionOffset = start + 3;
        break;
      case 'numbered':
        newText = text.replaceRange(start, end, '\n1. ');
        newSelectionOffset = start + 4;
        break;
      case 'quote':
        newText = text.replaceRange(start, end, '\n> ');
        newSelectionOffset = start + 3;
        break;
      case 'checkbox':
        newText = text.replaceRange(start, end, '\n- [ ] ');
        newSelectionOffset = start + 7;
        break;
      
      // New Formats from Bottom Sheet
      case 'title':
        _applyLinePrefix(start, '# ');
        return; // Early return as handled by helper
      case 'heading':
        _applyLinePrefix(start, '## ');
        return;
      case 'subheading':
        _applyLinePrefix(start, '### ');
        return;
      case 'body':
        _removeLinePrefix(start);
        return;
      
      case 'strikethrough':
        if (start == end) {
           newText = text.replaceRange(start, end, '~~~~');
           newSelectionOffset = start + 2;
        } else {
           final selected = text.substring(start, end);
           newText = text.replaceRange(start, end, '~~$selected~~');
           newSelectionOffset = end + 4;
        }
        break;
      
      case 'underline':
        // Markdown doesn't support underline well. Fallback to italic for now.
        _handleFormat('italic'); 
        return;
    }

    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_bodyFocusNode.hasFocus) _bodyFocusNode.requestFocus();
    });
  }

  void _applyLinePrefix(int cursorPosition, String prefix) {
     final text = _bodyController.text;
     // Find start of line
     int lineStart = text.lastIndexOf('\n', cursorPosition < text.length ? cursorPosition : cursorPosition - 1);
     if (lineStart == -1) {
       lineStart = 0;
     } else {
       lineStart += 1;
     }

     // Remove existing headers if any (# )
     // Regex to check if line starts with #+ 
     // For simplicity, just check current line content
     
     // Ideally we get the full line content to check replacement
     // Simplification: Just insert at start of line for now or replace if existing
     
     // Hard to robustly replace without full line scanning.
     // Let's just insert.
     
     final newText = text.replaceRange(lineStart, lineStart, prefix);
     
     _bodyController.value = TextEditingValue(
       text: newText,
       selection: TextSelection.collapsed(offset: cursorPosition + prefix.length),
     );
  }

  void _removeLinePrefix(int cursorPosition) {
     final text = _bodyController.text;
     int lineStart = text.lastIndexOf('\n', cursorPosition < text.length ? cursorPosition : cursorPosition - 1);
     if (lineStart == -1) {
       lineStart = 0;
     } else {
       lineStart += 1;
     }

     // Get rest of line to find what to remove
     // Simple check: if starts with #, remove it.
     
     final RegExp headerPattern = RegExp(r'^#{1,6}\s+');
     final RegExp listPattern = RegExp(r'^-\s+');
     final RegExp numListPattern = RegExp(r'^\d+\.\s+');
     final RegExp quotePattern = RegExp(r'^>\s+');
     
     // We need to look at the substring from lineStart to end of line or next newline
     int lineEnd = text.indexOf('\n', lineStart);
     if (lineEnd == -1) lineEnd = text.length;
     
     final lineText = text.substring(lineStart, lineEnd);
     
     String newText = text;
     int newCursor = cursorPosition;

     if (headerPattern.hasMatch(lineText)) {
       final match = headerPattern.firstMatch(lineText)!;
       newText = text.replaceRange(lineStart, lineStart + match.group(0)!.length, '');
       newCursor -= match.group(0)!.length;
     } else if (listPattern.hasMatch(lineText)) {
       final match = listPattern.firstMatch(lineText)!;
       newText = text.replaceRange(lineStart, lineStart + match.group(0)!.length, '');
       newCursor -= match.group(0)!.length;
     } else if (numListPattern.hasMatch(lineText)) {
       final match = numListPattern.firstMatch(lineText)!;
       newText = text.replaceRange(lineStart, lineStart + match.group(0)!.length, '');
       newCursor -= match.group(0)!.length;
     } else if (quotePattern.hasMatch(lineText)) {
       final match = quotePattern.firstMatch(lineText)!;
       newText = text.replaceRange(lineStart, lineStart + match.group(0)!.length, '');
       newCursor -= match.group(0)!.length;
     }

     if (newText != text) {
        _bodyController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newCursor < 0 ? 0 : newCursor),
        );
     }
  }
}
