import '../entities/complaint_model.dart';
import '../entities/complaint_stats_model.dart';

abstract class ComplainRepository {
  Future<List<Complaint>> getComplaints();
  Future<ComplaintStats> getComplaintStats();
  Future<void> updateComplaintStatus(String id, ComplaintStatus status);
  Future<void> createComplaint(Complaint complaint);
}
