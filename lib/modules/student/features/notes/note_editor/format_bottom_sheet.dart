import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class FormatBottomSheet extends StatelessWidget {
  final Function(String) onFormat;

  const FormatBottomSheet({super.key, required this.onFormat});

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Format',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 1: Text Styles (Title, Heading, etc.)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StyleButton(
                  label: 'Title',
                  onTap: () => onFormat('title'),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                _StyleButton(
                  label: 'Heading',
                  onTap: () => onFormat('heading'),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                _StyleButton(
                  label: 'Subheading',
                  onTap: () => onFormat('subheading'),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                _StyleButton(
                  label: 'Body',
                  onTap: () => onFormat('body'), // Clears headers
                  fontSize: 14,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Row 2: Character Formatting (B, I, U, S)
          Row(
            children: [
              _FormatIconButton(
                icon: Icons.format_bold,
                onTap: () => onFormat('bold'),
                label: 'B',
              ),
              const SizedBox(width: 8),
              _FormatIconButton(
                icon: Icons.format_italic,
                onTap: () => onFormat('italic'),
                label: 'I',
                fontStyle: FontStyle.italic,
              ),
              const SizedBox(width: 8),
              _FormatIconButton(
                icon: Icons.format_underline,
                onTap: () => onFormat('underline'), // Will likely map to italics or similar if markdown limited
                label: 'U',
              ),
              const SizedBox(width: 8),
              _FormatIconButton(
                icon: Icons.format_strikethrough,
                onTap: () => onFormat('strikethrough'),
                label: 'S',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Row 3: Lists & Indents
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                   _FormatIconButton(
                    icon: Icons.format_list_bulleted,
                    onTap: () => onFormat('list'),
                    isIcon: true,
                  ),
                   const SizedBox(width: 8),
                   _FormatIconButton(
                    icon: Icons.format_list_numbered,
                    onTap: () => onFormat('numbered'),
                    isIcon: true,
                  ),
                  const SizedBox(width: 8),
                  _FormatIconButton(
                    icon: Icons.checklist,
                    onTap: () => onFormat('checkbox'),
                    isIcon: true,
                  ),
                ],
              ),
              // Indent controls could go here if implemented
            ],
          ),
        ],
      ),
    );
  }
}

class _StyleButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final double fontSize;
  final FontWeight fontWeight;

  const _StyleButton({
    required this.label,
    required this.onTap,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black87,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _FormatIconButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final VoidCallback onTap;
  final bool isIcon;
  final FontStyle? fontStyle;

  const _FormatIconButton({
    this.icon,
    this.label,
    required this.onTap,
    this.isIcon = false,
    this.fontStyle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light grey button background
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isIcon 
            ? Icon(icon, color: AppColors.primary, size: 24)
            : Text(
                label ?? '',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontStyle: fontStyle,
                ),
              ),
      ),
    );
  }
}
