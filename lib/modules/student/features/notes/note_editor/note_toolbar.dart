import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border:
            Border(top: BorderSide(color: AppColors.primary.withOpacity(0.05))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _ToolbarButton(
              label: 'B',
              isText: true,
              onTap: () => onFormat('bold'),
            ),
            _ToolbarButton(
              label: 'I',
              isText: true,
              isItalic: true,
              onTap: () => onFormat('italic'),
            ),
            _ToolbarButton(
              label: 'U',
              isText: true,
              isUnderline: true,
              onTap: () => onFormat('underline'),
            ),
            _ToolbarButton(
              icon: Icons.format_list_bulleted_rounded,
              onTap: () => onFormat('bullet'),
            ),
            const VerticalDivider(width: 24, indent: 8, endIndent: 8),
            // _ToolbarButton(
            //   icon: Icons.image_outlined,
            //   onTap: () {},
            // ),
            // _ToolbarButton(
            //   icon: Icons.mic_none_outlined,
            //   onTap: () {},
            // ),
            // const Spacer(),
            // _ToolbarButton(
            //   icon: Icons.more_horiz_rounded,
            //   onTap: onOpenFormatSheet,
            // ),
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
  final bool isText;
  final bool isItalic;
  final bool isUnderline;

  const _ToolbarButton({
    this.icon,
    this.label,
    required this.onTap,
    this.isText = false,
    this.isItalic = false,
    this.isUnderline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: isText
              ? Text(
                  label!,
                  style: TextStyle(
                    color: AppColors.headerBlue.withOpacity(0.7),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
                    decoration: isUnderline
                        ? TextDecoration.underline
                        : TextDecoration.none,
                  ),
                )
              : Icon(
                  icon,
                  color: AppColors.headerBlue.withOpacity(0.7),
                  size: 24,
                ),
        ),
      ),
    );
  }
}
