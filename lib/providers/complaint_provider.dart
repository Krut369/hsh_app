import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/complaint_model.dart';

final selectedComplaintTypeProvider = StateProvider<ComplaintType?>((ref) => null);

final selectedSubComplaintsProvider = StateProvider<List<SubComplaint>>((ref) => []);

// Map of SubComplaint name to its description
final complaintDescriptionsProvider = StateProvider<Map<String, String>>((ref) => <String, String>{});

final selectedComplaintProvider = Provider<ComplaintType?>((ref) {
  return ref.watch(selectedComplaintTypeProvider);
});

final hasSubComplaintsProvider = Provider<bool>((ref) {
  final selectedType = ref.watch(selectedComplaintTypeProvider);
  return selectedType?.subComplaints.isNotEmpty ?? false;
});

final subComplaintsForTypeProvider = Provider<List<SubComplaint>>((ref) {
  final selectedType = ref.watch(selectedComplaintTypeProvider);
  return selectedType?.subComplaints ?? [];
});

// Mock complaints data - replace with actual data source later
final complaintsProvider = StateProvider<List<Complaint>>((ref) => [
  Complaint(
    id: '1',
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    complaintType: 'Electrical',
    descriptions: {
      'Fan': 'Fan not working in room 101',
      'Light': 'Light flickering in bathroom',
    },
    status: 'In Progress',
  ),
  Complaint(
    id: '2',
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    complaintType: 'Plumbing',
    descriptions: {
      'Tap': 'Water leakage from tap',
    },
    status: 'Completed',
  ),
  Complaint(
    id: '3',
    dateTime: DateTime.now().subtract(const Duration(hours: 5)),
    complaintType: 'Housekeeping',
    descriptions: {
      'Housekeeping': 'Room cleaning required',
    },
    status: 'Pending',
  ),
]);

// Filter for complaints list
final complaintFilterProvider = StateProvider<String>((ref) => 'All');

// Filtered complaints
final filteredComplaintsProvider = Provider<List<Complaint>>((ref) {
  final filter = ref.watch(complaintFilterProvider);
  final complaints = ref.watch(complaintsProvider);

  if (filter == 'All') return complaints;
  return complaints.where((complaint) => complaint.status == filter).toList();
});