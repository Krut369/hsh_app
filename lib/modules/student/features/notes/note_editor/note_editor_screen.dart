import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;
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
import 'custom_numbered_list_builder.dart';
import 'format_bottom_sheet.dart';
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
  bool _isBoldActive = false;
  bool _isItalicActive = false;
  bool _isUnderlineActive = false;
  bool _isBulletActive = false;

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
                      ? [
                          {'insert': note.body}
                        ]
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
        leading: BackButton(
          color: AppColors.white,
        ),
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
                      hintStyle: TextStyle(
                          color: AppColors.headerBlue.withValues(alpha: 0.2)),
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
                        blockComponentBuilders: {
                          ...standardBlockComponentBuilderMap,
                          NumberedListBlockKeys.type: buildCustomNumberedListBuilder(),
                        },
                        editorStyle: EditorStyle(
                          padding: EdgeInsets.zero,
                          cursorColor: AppColors.primary,
                          dragHandleColor:
                              AppColors.primary.withValues(alpha: 0.5),
                          selectionColor:
                              AppColors.primary.withValues(alpha: 0.2),
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
                    isBoldActive: _isBoldActive,
                    isItalicActive: _isItalicActive,
                    isUnderlineActive: _isUnderlineActive,
                    isBulletActive: _isBulletActive,
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
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => FormatBottomSheet(
        selectedFormat: _currentListFormat(),
        onFormat: (type) {
          Navigator.of(context).pop();
          _handleFormat(type);
        },
      ),
    );
  }

  void _cacheSelection() {
    final selection = _editorState.selection;
    if (selection != null) {
      _lastSelection = selection;
    }
    _updateFormattingState(selection);
  }

  void _updateFormattingState([Selection? selection]) {
    final currentSelection = selection ?? _editorState.selection ?? _lastSelection;
    final isBoldActive = _hasTextAttribute(
      AppFlowyRichTextKeys.bold,
      currentSelection,
    );
    final isItalicActive = _hasTextAttribute(
      AppFlowyRichTextKeys.italic,
      currentSelection,
    );
    final isUnderlineActive = _hasTextAttribute(
      AppFlowyRichTextKeys.underline,
      currentSelection,
    );
    final isBulletActive = _hasListSelection(currentSelection);

    if (!mounted) return;
    if (_isBoldActive == isBoldActive &&
        _isItalicActive == isItalicActive &&
        _isUnderlineActive == isUnderlineActive &&
        _isBulletActive == isBulletActive) {
      return;
    }

    setState(() {
      _isBoldActive = isBoldActive;
      _isItalicActive = isItalicActive;
      _isUnderlineActive = isUnderlineActive;
      _isBulletActive = isBulletActive;
    });
  }

  bool _hasListSelection(Selection? selection) {
    if (selection == null) return false;
    final nodes = _editorState.getNodesInSelection(selection);
    return nodes.any(
      (node) =>
          node.type == BulletedListBlockKeys.type ||
          node.type == NumberedListBlockKeys.type ||
          node.type == TodoListBlockKeys.type,
    );
  }

  String _currentListFormat([Selection? selection]) {
    final currentSelection = selection ?? _editorState.selection ?? _lastSelection;
    if (currentSelection == null) return 'paragraph';

    final node = _editorState.getNodeAtPath(currentSelection.normalized.start.path);
    switch (node?.type) {
      case BulletedListBlockKeys.type:
        return 'bullet';
      case NumberedListBlockKeys.type:
        final style = node?.attributes[CustomNumberedListStyles.styleKey]
                as String? ??
            CustomNumberedListStyles.decimal;
        switch (style) {
          case CustomNumberedListStyles.alpha:
            return 'numbered_alpha';
          case CustomNumberedListStyles.roman:
            return 'numbered_roman';
          case CustomNumberedListStyles.decimal:
          default:
            return 'numbered_decimal';
        }
      case TodoListBlockKeys.type:
        return 'checkbox';
      default:
        return 'paragraph';
    }
  }

  bool _hasTextAttribute(String attributeKey, Selection? selection) {
    if (selection == null) return false;

    final normalized = selection.normalized;
    final nodes = _editorState.getNodesInSelection(normalized);

    for (final node in nodes) {
      final delta = node.delta;
      if (delta == null) continue;

      if (selection.isCollapsed && node.path.equals(normalized.start.path)) {
        final attributes =
            appflowyEditorSliceAttributes?.call(delta, normalized.start.offset);
        if (attributes?[attributeKey] == true) {
          return true;
        }
        continue;
      }

      final startIndex =
          node.path.equals(normalized.start.path) ? normalized.startIndex : 0;
      final endIndex = node.path.equals(normalized.end.path)
          ? normalized.endIndex
          : delta.length;
      if (endIndex <= startIndex) continue;

      final sliced = delta.slice(startIndex, endIndex);
      for (final operation in sliced) {
        if (operation.attributes?[attributeKey] == true) {
          return true;
        }
      }
    }

    return false;
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
        await _applyListFormat(selection, BulletedListBlockKeys.type);
        break;
      case 'numbered_decimal':
        await _applyListFormat(
          selection,
          NumberedListBlockKeys.type,
          attributes: {
            CustomNumberedListStyles.styleKey:
                CustomNumberedListStyles.decimal,
          },
        );
        break;
      case 'numbered_alpha':
        await _applyListFormat(
          selection,
          NumberedListBlockKeys.type,
          attributes: {
            CustomNumberedListStyles.styleKey:
                CustomNumberedListStyles.alpha,
          },
        );
        break;
      case 'numbered_roman':
        await _applyListFormat(
          selection,
          NumberedListBlockKeys.type,
          attributes: {
            CustomNumberedListStyles.styleKey:
                CustomNumberedListStyles.roman,
          },
        );
        break;
      case 'checkbox':
        await _applyListFormat(
          selection,
          TodoListBlockKeys.type,
          attributes: {
            TodoListBlockKeys.checked: false,
          },
        );
        break;
      case 'paragraph':
        await _applyListFormat(selection, ParagraphBlockKeys.type);
        break;
    }

    _updateFormattingState(_editorState.selection ?? selection);
  }

  Future<void> _applyListFormat(
    Selection selection,
    String targetType, {
    Map<String, dynamic>? attributes,
  }) async {
    await _editorState.formatNode(
      selection,
      (node) {
        final sameType = node.type == targetType;
        final requestedStyle = attributes?[CustomNumberedListStyles.styleKey];
        final existingStyle =
            node.attributes[CustomNumberedListStyles.styleKey];
        final sameStyle = requestedStyle == null || requestedStyle == existingStyle;
        final nextType =
            sameType && sameStyle ? ParagraphBlockKeys.type : targetType;
        final nextAttributes = Map<String, dynamic>.from(node.attributes)
          ..remove(TodoListBlockKeys.checked)
          ..remove(NumberedListBlockKeys.number)
          ..remove(CustomNumberedListStyles.styleKey);

        if (attributes != null) {
          nextAttributes.addAll(attributes);
        }
        if (nextType == TodoListBlockKeys.type ||
            node.type == TodoListBlockKeys.type) {
          nextAttributes[ParagraphBlockKeys.delta] =
              (node.delta ?? Delta()).toJson();
        }

        return node.copyWith(
          type: nextType,
          attributes: nextAttributes,
        );
      },
    );
  }
}
