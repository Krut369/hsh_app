import 'dart:io';
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
      // V2 returns: { status, results, data: { complains: [...] } }
      List<dynamic> list = [];
      if (data is Map) {
        final inner = data['data'] ?? data;
        if (inner is Map) {
          list = (inner['complains'] ?? inner['data'] ?? []) as List<dynamic>;
        } else if (inner is List) {
          list = inner;
        }
      } else if (data is List) {
        list = data;
      }
      return list.map((e) => Complaint.fromJson(e as Map<String, dynamic>)).toList();
    }
    return [];
  }

  @override
  Future<ComplaintStats> getComplaintStats() async {
    final complaints = await getComplaints();
    int pending = 0, resolved = 0, inProgress = 0;
    for (final c in complaints) {
      switch (c.status) {
        case ComplaintStatus.pending:
          pending++;
          break;
        case ComplaintStatus.resolved:
          resolved++;
          break;
        case ComplaintStatus.underReview:
        case ComplaintStatus.awaitingFeedback:
          inProgress++;
          break;
      }
    }
    return ComplaintStats(
      total: complaints.length,
      pending: pending,
      inProgress: inProgress,
      resolved: resolved,
    );
  }

  @override
  Future<void> updateComplaintStatus(String id, ComplaintStatus status) async {
    final intId = int.tryParse(id) ?? 0;
    final response = await _service.updateComplaintStatus(
      id: intId,
      status: status.toBackendString,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update status');
    }
  }

  @override
  Future<void> createComplaint(Complaint complaint) async {
    final response = await _service.createComplaint(
      room: complaint.room ?? '',
      aadhar: complaint.aadhar ?? '',
      compType: complaint.compType,
      compDesc: complaint.compDesc,
      images: null,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to create complaint');
    }
  }

  /// Create complaint with photo attachments
  Future<void> createComplaintWithImages({
    required String room,
    required String aadhar,
    required String compType,
    required String compDesc,
    List<File>? images,
  }) async {
    final response = await _service.createComplaint(
      room: room,
      aadhar: aadhar,
      compType: compType,
      compDesc: compDesc,
      images: images,
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Failed to create complaint');
    }
  }

  /// Get complaint categories from API
  Future<List<String>> getCategories() async {
    final response = await _service.getCategories();
    if (response.success && response.data != null) {
      final data = response.data;
      if (data is Map) {
        final inner = data['data'] ?? data;
        if (inner is Map) {
          final categories = inner['categories'];
          if (categories is List) {
            return categories.map((e) => e.toString()).toList();
          }
        }
      }
    }
    return ['Cleaning', 'Electrical', 'Furniture', 'Internet', 'Other', 'Plumbing'];
  }
}
