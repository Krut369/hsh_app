import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/models/complaint_stats_model.dart';
import 'package:hsh_app/services/service_provider.dart';

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

// Global provider to fetch complaints list
final complaintsListProvider = FutureProvider<List<Complaint>>((ref) async {
  final response = await serviceProvider.complaint.getComplaints();
  if (response.success && response.data != null) {
      // Assuming backend returns { data: [...] } or just array in data
      // Based on API implementation, likely response.data['data'] is the list
      // Or if data is the list directly.
      // Standard structure: { success: true, data: [ ... ] }
      
      final data = response.data;
      final List<dynamic> list = (data is Map && data.containsKey('data')) 
          ? (data['data'] as List<dynamic>)
          : (data is List ? data : []);

      return list.map((e) => Complaint.fromJson(e)).toList();
  }
  return [];
});

final complaintFilterProvider = StateProvider<ComplaintStatus?>((ref) => null);

final filteredComplaintsProvider = Provider<AsyncValue<List<Complaint>>>((ref) {
  final complaintsAsync = ref.watch(complaintsListProvider);
  final filter = ref.watch(complaintFilterProvider);

  return complaintsAsync.whenData((complaints) {
    if (filter == null) {
      return complaints;
    }
    return complaints.where((c) => c.status == filter).toList();
  });
});

final complaintStatsProvider = FutureProvider<ComplaintStats>((ref) async {
  final response = await serviceProvider.complaint.getComplaintStats();
  if (response.success && response.data != null) {
      return ComplaintStats.fromJson(response.data);
  }
  return ComplaintStats.empty();
});
