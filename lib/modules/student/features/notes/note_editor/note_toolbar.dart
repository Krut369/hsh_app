import 'package:flutter/material.dart';

class NoteToolbar extends StatelessWidget {
  final Function(String) onFormat;
  final VoidCallback onOpenFormatSheet;

  const NoteToolbar({
    super.key,
    required this.onFormat,
    required this.onOpenFormatSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E), // Dark background matching screenshots
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             _ToolbarButton(
              icon: Icons.text_format, // "Aa" icon equivalent
              label: 'Aa',
              isText: true,
              onTap: onOpenFormatSheet,
              tooltip: 'Format',
            ),
            _ToolbarButton(
              icon: Icons.checklist,
              onTap: () => onFormat('checkbox'),
              tooltip: 'Checklist',
            ),
            _ToolbarButton(
              icon: Icons.grid_on, // Table placeholder
              onTap: () => onFormat('table'),
              tooltip: 'Table',
            ),
            _ToolbarButton(
              icon: Icons.attach_file,
              onTap: () {}, 
              tooltip: 'Attach',
            ),
            _ToolbarButton(
              icon: Icons.auto_awesome, // AI/Magic placeholder
              onTap: () {},
              tooltip: 'Magic',
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final String tooltip;
  final bool isText;

  const _ToolbarButton({
    this.icon,
    this.label,
    required this.onTap,
    this.tooltip = '',
    this.isText = false,
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
            child: isText
                ? Text(
                    label!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Icon(
                    icon,
                    color: Colors.white,
                    size: 24, 
                  ),
          ),
        ),
      ),
    );
  }
}
