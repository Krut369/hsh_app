import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/app_text.dart';
import '../../../../models/note_model.dart';
import '../../../../providers/notes_provider.dart';
import '../../widgets/note_components.dart';
import 'markdown_controller.dart';
import 'note_toolbar.dart';

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

  @override
  void initState() {
    super.initState();
    
    // Initialize with existing data if editing
    if (_isEditing) {
      final note = widget.noteToEdit!;
      _titleController.text = note.title;
      _selectedTag = note.category;
      _bodyController = MarkdownSyntaxController(text: note.body);
    } else {
      _bodyController = MarkdownSyntaxController();
    }
    
    _bodyController.addListener(() {
      if (_bodyFocusNode.hasFocus && _bodyController.selection.isValid) {
        _lastSelection = _bodyController.selection;
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
            child: TextButton(
              onPressed: _saveNote,
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
          
          // Custom Toolbar
          NoteToolbar(
            onFormat: _handleFormat,
          ), 
        ],
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

  void _saveNote() {
    if (_titleController.text.trim().isEmpty && _bodyController.text.trim().isEmpty) {
        // Empty note?
        Navigator.pop(context);
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

    ref.read(notesProvider.notifier).addNote(newNote);
    Navigator.pop(context);
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
      case 'checkbox':
        newText = text.replaceRange(start, end, '\n- [ ] ');
        newSelectionOffset = start + 7;
        break;
    }

    _bodyController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionOffset),
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bodyFocusNode.requestFocus();
    });
  }
}
