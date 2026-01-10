// lib/modules/student/widgets/profile_info_chip.dart
import 'package:flutter/material.dart';

class ProfileInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final double? fontSize;
  final double? valueFont;

  const ProfileInfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.fontSize,
    this.valueFont,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.13),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: (fontSize ?? 15) + 7),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: fontSize ?? 15,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: valueFont ?? 16,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 2,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
