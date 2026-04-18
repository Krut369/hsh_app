import 'package:flutter/material.dart';
import 'package:hsh_app/models/leave_request_model.dart';

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequest request;
  final Function(LeaveRequest) onApprove;
  final Function(LeaveRequest) onReject;
  final VoidCallback? onTap;

  const LeaveRequestCard({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isPending = request.status == LeaveStatus.pending;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1D3557).withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  request.studentAvatar,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 50,
                    height: 50,
                    color: const Color(0xFFE9F1F8),
                    child: const Icon(Icons.person, color: Color(0xFF2D507B)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.studentName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1D3557),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(_getLeaveIcon(request.leaveType),
                            size: 14, color: const Color(0xFF6B7A8A)),
                        const SizedBox(width: 4),
                        Text(
                          request.leaveType,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7A8A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFDCE6F1)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isPending ? 'PENDING' : 'PROCESSED',
                  style: TextStyle(
                    color: isPending
                        ? const Color(0xFF1D3557).withValues(alpha: 0.5)
                        : const Color(0xFF4A5568),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Duration & Dates Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4F8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DURATION',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9BABBB),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${request.durationInDays} ${request.durationInDays > 1 ? 'Days' : 'Day'}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: const Color(0xFFDCE6F1),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DATES',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9BABBB),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDates(request.startDate, request.endDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D3557),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          if (isPending)
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => onApprove(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D253F),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => onReject(request),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2E8F0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(
                          color: Color(0xFF4A5568),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            Center(
              child: Text(
                'Approved by Admin on ${_formatProcessedDate(request.processedAt)}',
                style: const TextStyle(
                  color: Color(0xFF9BABBB),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getLeaveIcon(String type) {
    if (type.contains('Home')) return Icons.home_outlined;
    if (type.contains('Medical')) return Icons.medical_services_outlined;
    return Icons.celebration_outlined;
  }

  String _formatDates(DateTime start, DateTime end) {
    if (start.month == end.month && start.year == end.year) {
      if (start.day == end.day) {
        return '${_getMonthName(start.month)} ${start.day}, ${start.year}';
      }
      return '${_getMonthName(start.month)} ${start.day} - ${end.day}';
    }
    return '${_getMonthName(start.month)} ${start.day} - ${_getMonthName(end.month)} ${end.day}';
  }

  String _formatProcessedDate(DateTime? date) {
    if (date == null) return 'Oct 18';
    return '${_getMonthName(date.month)} ${date.day}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
