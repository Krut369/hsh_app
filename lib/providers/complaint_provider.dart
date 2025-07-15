import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/complaint_model.dart';

// Selected complaint type
final selectedComplaintTypeProvider = StateProvider<ComplaintType?>((ref) => null);

// Selected sub-complaints under a type
final selectedSubComplaintsProvider = StateProvider<List<SubComplaint>>((ref) => []);

// Map of sub-complaint name to description
final complaintDescriptionsProvider = StateProvider<Map<String, String>>((ref) => <String, String>{});

// Shortcut provider to get currently selected complaint type
final selectedComplaintProvider = Provider<ComplaintType?>((ref) {
  return ref.watch(selectedComplaintTypeProvider);
});

// Check if selected type has sub-complaints
final hasSubComplaintsProvider = Provider<bool>((ref) {
  final selectedType = ref.watch(selectedComplaintTypeProvider);
  return selectedType?.subComplaints.isNotEmpty ?? false;
});

// Get sub-complaints of the selected type
final subComplaintsForTypeProvider = Provider<List<SubComplaint>>((ref) {
  final selectedType = ref.watch(selectedComplaintTypeProvider);
  return selectedType?.subComplaints ?? [];
});

// ✅ Updated complaints list using ComplaintStatus enum
final complaintsProvider = StateProvider<List<Complaint>>((ref) => [
  Complaint(
    id: '1',
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    complaintType: 'Electrical',
    descriptions: {
      'Fan': 'Fan not working in room 101',
      'Light': 'Light flickering in bathroom',
    },
    status: ComplaintStatus.underReview,
  ),
  Complaint(
    id: '2',
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    complaintType: 'Plumbing',
    descriptions: {
      'Tap': 'Water leakage from tap',
    },
    status: ComplaintStatus.resolved,
  ),
  Complaint(
    id: '3',
    dateTime: DateTime.now().subtract(const Duration(hours: 5)),
    complaintType: 'Housekeeping',
    descriptions: {
      'Housekeeping': 'Room cleaning required',
    },
    status: ComplaintStatus.pending,
  ),
]);

// ✅ Use enum for filter
final complaintFilterProvider = StateProvider<ComplaintStatus?>((ref) => null); // null = 'All'

// ✅ Filtered complaints based on selected status
final filteredComplaintsProvider = Provider<List<Complaint>>((ref) {
  final filter = ref.watch(complaintFilterProvider);
  final complaints = ref.watch(complaintsProvider);

  if (filter == null) return complaints; // Show all
  return complaints.where((complaint) => complaint.status == filter).toList();


});

// Total complaint count
final totalComplaintCountProvider = Provider<int>((ref) {
  return ref.watch(complaintsProvider).length;
});

// Count per status
final complaintCountByStatusProvider = Provider.family<int, ComplaintStatus>((ref, status) {
  return ref
      .watch(complaintsProvider)
      .where((complaint) => complaint.status == status)
      .length;
});

