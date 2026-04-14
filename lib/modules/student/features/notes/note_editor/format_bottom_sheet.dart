import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class FormatBottomSheet extends StatelessWidget {
  final Function(String) onFormat;
  final String selectedFormat;

  const FormatBottomSheet({
    super.key,
    required this.onFormat,
    this.selectedFormat = 'paragraph',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'List Style',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Choose how you want the current line or selected lines to appear.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          _ListOptionTile(
            icon: Icons.format_list_bulleted_rounded,
            label: 'Bulleted List',
            value: 'bullet',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('bullet'),
          ),
          const SizedBox(height: 10),
          _ListOptionTile(
            icon: Icons.format_list_numbered_rounded,
            label: '1. 2. 3.',
            value: 'numbered_decimal',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('numbered_decimal'),
          ),
          const SizedBox(height: 10),
          _ListOptionTile(
            icon: Icons.format_list_numbered_rounded,
            label: 'a. b. c.',
            value: 'numbered_alpha',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('numbered_alpha'),
          ),
          const SizedBox(height: 10),
          _ListOptionTile(
            icon: Icons.format_list_numbered_rounded,
            label: 'i. ii. iii.',
            value: 'numbered_roman',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('numbered_roman'),
          ),
          const SizedBox(height: 10),
          _ListOptionTile(
            icon: Icons.checklist_rounded,
            label: 'Checklist',
            value: 'checkbox',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('checkbox'),
          ),
          const SizedBox(height: 10),
          _ListOptionTile(
            icon: Icons.notes_rounded,
            label: 'Normal Text',
            value: 'paragraph',
            selectedFormat: selectedFormat,
            onTap: () => onFormat('paragraph'),
          ),
        ],
      ),
    );
  }
}

class _ListOptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String selectedFormat;
  final VoidCallback onTap;

  const _ListOptionTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.selectedFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedFormat == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.10)
              : AppColors.border.withOpacity(0.18),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.35)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_rounded,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
