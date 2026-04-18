import 'package:flutter/material.dart';

class AttendanceStatsCard extends StatelessWidget {
  final String total;
  final String present;
  final String absent;

  const AttendanceStatsCard({
    super.key,
    required this.total,
    required this.present,
    required this.absent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D3557).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat('TOTAL', total, const Color(0xFF1D3557)),
          _buildStat('PRESENT', present, const Color(0xFF10B981)),
          _buildStat('ABSENT', absent, const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Color(0xFF94A3B8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
