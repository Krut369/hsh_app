import 'package:flutter/material.dart';

class NoteToolbar extends StatelessWidget {
  final Function(String) onFormat;

  const NoteToolbar({
    super.key,
    required this.onFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Light background like iOS keyboard accessory
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             _ToolbarButton(
              icon: Icons.format_bold,
              onTap: () => onFormat('bold'),
              tooltip: 'Bold',
            ),
            _ToolbarButton(
              icon: Icons.format_italic,
              onTap: () => onFormat('italic'),
              tooltip: 'Italic',
            ),
            _ToolbarButton(
              icon: Icons.format_list_bulleted,
              onTap: () => onFormat('list'),
              tooltip: 'List',
            ),
            _ToolbarButton(
              icon: Icons.check_box_outlined,
              onTap: () => onFormat('checkbox'),
              tooltip: 'Checklist',
            ),
            // Placeholder for future features (e.g. Image, Table)
            _ToolbarButton(
              icon: Icons.camera_alt_outlined,
              onTap: () {}, 
              color: Colors.grey[400], // Disabled look or secondary
              tooltip: 'Camera',
            ),
            _ToolbarButton(
              icon: Icons.edit_note, // Scribble/Drawing icon placeholder
              onTap: () {},
              color: Colors.grey[400],
              tooltip: 'Draw',
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color? color;

  const _ToolbarButton({
    required this.icon,
    required this.onTap,
    this.tooltip = '',
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              icon,
              color: color ?? Colors.black87,
              size: 26, 
            ),
          ),
        ),
      ),
    );
  }
}
