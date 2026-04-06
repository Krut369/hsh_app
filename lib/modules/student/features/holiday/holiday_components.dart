import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hsh_app/models/leave_request_model.dart';

class HolidayEmptyState extends StatelessWidget {
  const HolidayEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(
              Icons.beach_access_rounded,
              size: 48,
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Leaves Found',
            style: TextStyle(
              color: Color(0xFF1D3557),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You haven't requested any leaves yet.",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

extension LeaveStatusExtension on LeaveStatus {
  String get label {
    switch (this) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
    }
  }

  Color get color {
    switch (this) {
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.approved:
        return const Color(0xFF10B981); // Modern green
      case LeaveStatus.rejected:
        return const Color(0xFFEF4444); // Modern red
    }
  }
}

class HolidayStatusTag extends StatelessWidget {
  final LeaveStatus status;

  const HolidayStatusTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: TextStyle(
          color: status.color,
          fontWeight: FontWeight.bold,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class HolidayListTile extends StatelessWidget {
  final LeaveRequest holiday;

  const HolidayListTile({super.key, required this.holiday});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Calculate duration
    final duration = holiday.endDate.difference(holiday.startDate).inDays + 1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBF3F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flight_takeoff_rounded,
                    color: const Color(0xFF1D3557),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holiday.leaveType, // Changed from name to leaveType
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$duration days leave',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                HolidayStatusTag(status: holiday.status),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDateBox(context, 'From', holiday.startDate),
                Icon(Icons.arrow_forward_rounded,
                    size: 16, color: Colors.grey[400]),
                _buildDateBox(context, 'To', holiday.endDate),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateBox(BuildContext context, String label, DateTime date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DateFormat('dd MMM yyyy').format(date),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
