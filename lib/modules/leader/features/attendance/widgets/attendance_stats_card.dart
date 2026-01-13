import 'package:flutter/material.dart';

class AttendanceStatsCard extends StatelessWidget {
  final String present;
  final String absent;
  final String total;

  const AttendanceStatsCard({
    super.key,
    required this.present,
    required this.absent,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(label: 'Present', value: present, color: Colors.green),
        _StatItem(label: 'Absent', value: absent, color: Colors.red),
        _StatItem(label: 'Total', value: total, color: const Color(0xFF2D507B)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5D90B3),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
