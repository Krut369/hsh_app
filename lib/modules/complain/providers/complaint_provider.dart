import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/complaint_model.dart';

// --- State Management for Adding Complaint ---

class AddComplaintState {
  final ComplaintType? selectedType;
  final List<SubComplaint> selectedSubComplaints;
  final Map<String, ComplaintIssueData> issues; // SubComplaint name -> Data

  AddComplaintState({
    this.selectedType,
    this.selectedSubComplaints = const [],
    this.issues = const {},
  });

  AddComplaintState copyWith({
    ComplaintType? selectedType,
    List<SubComplaint>? selectedSubComplaints,
    Map<String, ComplaintIssueData>? issues,
  }) {
    return AddComplaintState(
      selectedType: selectedType ?? this.selectedType,
      selectedSubComplaints: selectedSubComplaints ?? this.selectedSubComplaints,
      issues: issues ?? this.issues,
    );
  }
}

class AddComplaintNotifier extends Notifier<AddComplaintState> {
  @override
  AddComplaintState build() {
    return AddComplaintState();
  }

  void selectType(ComplaintType type) {
    state = AddComplaintState(selectedType: type);
  }

  void toggleSubComplaint(SubComplaint sub) {
    final currentList = List<SubComplaint>.from(state.selectedSubComplaints);
    if (currentList.contains(sub)) {
      currentList.remove(sub);
      // Optional: don't clear data immediately so it recovers if re-selected?
      // Or clear it to be clean. Let's clear it.
      final newIssues = Map<String, ComplaintIssueData>.from(state.issues);
      newIssues.remove(sub.name);
      state = state.copyWith(selectedSubComplaints: currentList, issues: newIssues);
    } else {
      currentList.add(sub);
      state = state.copyWith(selectedSubComplaints: currentList);
    }
  }

  void updateIssueDescription(String key, String description) {
    final currentIssues = Map<String, ComplaintIssueData>.from(state.issues);
    final existing = currentIssues[key] ?? ComplaintIssueData(description: '');
    currentIssues[key] = ComplaintIssueData(
      description: description,
      imagePath: existing.imagePath,
    );
    state = state.copyWith(issues: currentIssues);
  }

  void updateIssueImage(String key, String? imagePath) {
    final currentIssues = Map<String, ComplaintIssueData>.from(state.issues);
    final existing = currentIssues[key] ?? ComplaintIssueData(description: '');
    currentIssues[key] = ComplaintIssueData(
      description: existing.description,
      imagePath: imagePath,
    );
    state = state.copyWith(issues: currentIssues);
  }

  void reset() {
    state = AddComplaintState();
  }
}

final addComplaintProvider = NotifierProvider<AddComplaintNotifier, AddComplaintState>(AddComplaintNotifier.new);

// --- Global Complaint List ---

// ✅ Updated complaints list using ComplaintStatus enum
final complaintsProvider = StateProvider<List<Complaint>>((ref) => [
  Complaint(
    id: '1',
    dateTime: DateTime.now().subtract(const Duration(days: 1)),
    complaintType: 'Electrical',
    issues: {
      'Fan': ComplaintIssueData(description: 'Fan not working in room 101'),
      'Light': ComplaintIssueData(description: 'Light flickering in bathroom'),
    },
    status: ComplaintStatus.underReview,
  ),
  Complaint(
    id: '2',
    dateTime: DateTime.now().subtract(const Duration(days: 2)),
    complaintType: 'Plumbing',
    issues: {
      'Tap': ComplaintIssueData(description: 'Water leakage from tap'),
    },
    status: ComplaintStatus.resolved,
  ),
  Complaint(
    id: '3',
    dateTime: DateTime.now().subtract(const Duration(hours: 5)),
    complaintType: 'Housekeeping',
    issues: {
      'Housekeeping': ComplaintIssueData(description: 'Room cleaning required'),
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

