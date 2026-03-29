import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:uuid/uuid.dart';

class ChecklistItem {
  String id;
  String text;
  bool isDone;

  ChecklistItem({
    required this.id,
    required this.text,
    this.isDone = false,
  });
}

class _ItemData {
  final ChecklistItem item;
  final TextEditingController controller;
  final FocusNode focusNode;

  _ItemData({
    required this.item,
    required this.controller,
    required this.focusNode,
  });

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class ChecklistEditor extends StatefulWidget {
  final List<ChecklistItem> items;
  final Function(List<ChecklistItem>) onChanged;

  const ChecklistEditor({
    super.key,
    required this.items,
    required this.onChanged,
  });

  @override
  State<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<ChecklistEditor> {
  late List<_ItemData> _itemDataList;

  @override
  void initState() {
    super.initState();
    _initDataList();
  }

  void _initDataList() {
    _itemDataList = widget.items.map((item) {
      return _ItemData(
        item: item,
        controller: TextEditingController(text: item.text),
        focusNode: FocusNode(),
      );
    }).toList();

    if (_itemDataList.isEmpty) {
      _addItem(0, autofocus: false);
    }
  }

  void _notifyChanges() {
    final updatedItems = _itemDataList.map((d) => d.item).toList();
    widget.onChanged(updatedItems);
  }

  void _addItem(int index, {bool autofocus = true}) {
    final newItem = ChecklistItem(id: const Uuid().v4(), text: '');
    final newData = _ItemData(
      item: newItem,
      controller: TextEditingController(),
      focusNode: FocusNode(),
    );

    setState(() {
      if (_itemDataList.isEmpty || index >= _itemDataList.length) {
        _itemDataList.add(newData);
      } else {
        _itemDataList.insert(index + 1, newData);
      }
    });

    if (autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        newData.focusNode.requestFocus();
      });
    }
    _notifyChanges();
  }

  void _removeItem(int index) {
    if (_itemDataList.length == 1) {
      setState(() {
        _itemDataList[0].item.text = '';
        _itemDataList[0].item.isDone = false;
        _itemDataList[0].controller.clear();
      });
      _notifyChanges();
      return;
    }

    setState(() {
      final removed = _itemDataList.removeAt(index);
      removed.dispose();
    });
    _notifyChanges();
  }

  @override
  void dispose() {
    for (var data in _itemDataList) {
      data.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      onReorder: (oldIndex, newIndex) {
        if (oldIndex < _itemDataList.length && newIndex <= _itemDataList.length) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              if (newIndex >= _itemDataList.length) newIndex = _itemDataList.length - 1;
              final item = _itemDataList.removeAt(oldIndex);
              _itemDataList.insert(newIndex, item);
            });
            _notifyChanges();
        }
      },
      itemCount: _itemDataList.length + 1,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        if (index == _itemDataList.length) {
          return Padding(
            key: const ValueKey('add_item_button'),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: InkWell(
              onTap: () => _addItem(_itemDataList.length - 1),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Add item',
                      style: AppFonts.bodyRegular(context).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        final data = _itemDataList[index];
        return Container(
          key: ValueKey(data.item.id),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_indicator, color: AppColors.textSecondary, size: 20),
                ),
                Checkbox(
                  value: data.item.isDone,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
                    setState(() {
                      data.item.isDone = val ?? false;
                    });
                    _notifyChanges();
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: data.controller,
                    focusNode: data.focusNode,
                    onChanged: (val) {
                      data.item.text = val;
                      _notifyChanges();
                    },
                    onSubmitted: (_) => _addItem(index),
                    style: AppFonts.bodyRegular(context).copyWith(
                      decoration: data.item.isDone ? TextDecoration.lineThrough : null,
                      color: data.item.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Task...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.cancelledRed, size: 20),
                  onPressed: () => _removeItem(index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


