import 'package:flutter/material.dart';
import 'package:hsh_app/models/leave_request_model.dart';
import 'package:intl/intl.dart';

class LeaveDetailScreen extends StatelessWidget {
  final LeaveRequest request;
  final Function(LeaveRequest) onApprove;
  final Function(LeaveRequest) onReject;

  const LeaveDetailScreen({
    super.key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        title: const Text('Request Details'),
        backgroundColor: const Color(0xFF3D5A80),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person, size: 30),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(request.studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Room ${request.room}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _buildDetailRow('Leave Type', request.leaveType),
                  _buildDetailRow('Duration', '${DateFormat('MMM dd, yyyy').format(request.startDate)} - ${DateFormat('MMM dd, yyyy').format(request.endDate)}'),
                  _buildDetailRow('Total Days', '${request.durationInDays} Days'),
                  const SizedBox(height: 16),
                  const Text('Reason', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(request.reason, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 32),
                  if (request.status == LeaveStatus.pending)
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onApprove(request);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                            child: const Text('Approve'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              onReject(request);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            child: const Text('Reject'),
                          ),
                        ),
                      ],
                    )
                  else
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: request.status == LeaveStatus.approved ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          request.status.name.toUpperCase(),
                          style: TextStyle(
                            color: request.status == LeaveStatus.approved ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
