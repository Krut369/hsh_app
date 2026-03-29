import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_stats_model.dart';
import 'package:hsh_app/modules/complain/domain/repositories/complain_repository.dart';
import 'package:hsh_app/services/service_provider.dart';

class ComplainRepositoryImpl implements ComplainRepository {
  final _service = serviceProvider.complaint;

  @override
  Future<List<Complaint>> getComplaints() async {
    final response = await _service.getComplaints();
    if (response.success && response.data != null) {
      final data = response.data;
      final List<dynamic> list = (data is Map && data.containsKey('data'))
          ? (data['data'] as List<dynamic>)
          : (data is List ? data : []);
      return list.map((e) => Complaint.fromJson(e)).toList();
    } else {
      print('=== API FAILED OR RETURNED NULL DATA ===');
      print('Success: ${response.success}');
      print('Message: ${response.message}');
      print('Data: ${response.data}');
    }
    return [];
  }

  @override
  Future<ComplaintStats> getComplaintStats() async {
    final response = await _service.getComplaintStats();
    if (response.success && response.data != null) {
      return ComplaintStats.fromJson(response.data);
    }
    return ComplaintStats.empty();
  }

  @override
  Future<void> updateComplaintStatus(String id, ComplaintStatus status) async {
    final response = await _service.updateComplaintStatus(
      complaintId: id,
      status: status.toBackendString,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update status');
    }
  }

  @override
  Future<void> createComplaint(Complaint complaint) async {
    // Map list of issues to the format expected by the API
    final List<Map<String, dynamic>> processedIssues = [];

    complaint.issues.forEach((subName, issueData) {
      processedIssues.add({
        'sub_category': subName,
        'description': issueData.description,
        'imagePath': issueData.imagePath, // Service will handle the upload
      });
    });

    final response = await _service.createComplaint(
      complaintType: complaint.complaintType,
      issues: processedIssues,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to create complaint');
    }
  }
}
