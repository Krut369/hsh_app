import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';

class VehicleDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const VehicleDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey.withOpacity(0.7), fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
