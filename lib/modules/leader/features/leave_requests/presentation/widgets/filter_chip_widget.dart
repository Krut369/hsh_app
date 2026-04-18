import 'package:flutter/material.dart';
import 'package:hsh_app/models/leave_request_model.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final LeaveStatus? status;
  final bool isSelected;
  final Function(LeaveStatus?) onTap;
  final int? count;

  const FilterChipWidget({
    super.key,
    required this.label,
    this.status,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF2D507B).withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected 
            ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]
            : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF1D3557) : Colors.white.withValues(alpha: 0.8),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
