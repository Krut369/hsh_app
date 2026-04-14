import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_stats_model.dart';
import 'package:hsh_app/modules/complain/domain/usecases/get_complaints_usecase.dart';
import 'package:hsh_app/modules/complain/domain/repositories/complain_repository.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' hide AppColors;

class ComplainController extends GetxController {
  final GetComplaintsUseCase _getComplaintsUseCase;
  final ComplainRepository
      _repository; // Simple for secondary operations or use cases

  ComplainController({
    required GetComplaintsUseCase getComplaintsUseCase,
    required ComplainRepository repository,
  })  : _getComplaintsUseCase = getComplaintsUseCase,
        _repository = repository;

  // Observables
  final complaints = <Complaint>[].obs;
  final stats = ComplaintStats.empty().obs;
  final isLoading = false.obs;
  final error = RxnString();
  final filter = Rxn<ComplaintStatus>();
  final categoryFilter = RxnString();
  final categoryCounts = <String, int>{}.obs;
  final tabIndex = 0.obs;

  // Selection/Draft State (for Add Complaint)
  final selectedType = Rxn<ComplaintType>();
  final selectedSubComplaints = <SubComplaint>[].obs;
  final issues = <String, ComplaintIssueData>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchComplaints();
    fetchStats();
  }

  Future<void> fetchComplaints() async {
    isLoading.value = true;
    error.value = null;
    try {
      final fetchedList = await _getComplaintsUseCase.execute();
      complaints.assignAll(fetchedList);
      _calculateStatsLocally();
    } catch (e) {
      debugPrint('=== COMPLAINTS FETCH ERROR ===');
      debugPrint(e.toString());
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _calculateStatsLocally() {
    int pending = 0;
    int resolved = 0;
    int inProgress = 0;

    categoryCounts.clear();

    for (var complaint in complaints) {
      // Status Stats
      switch (complaint.status) {
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

      // Category Stats
      final cat = complaint.complaintType;
      categoryCounts[cat] = (categoryCounts[cat] ?? 0) + 1;
    }

    stats.value = ComplaintStats(
      total: complaints.length,
      pending: pending,
      resolved: resolved,
      inProgress: inProgress,
    );
  }

  Future<void> fetchStats() async {
    // Rely on local calculation to ensure stats are perfectly synced with the complaints list
    _calculateStatsLocally();
  }

  void setFilter(ComplaintStatus? newFilter) {
    filter.value = newFilter;
  }

  void setCategoryFilter(String? categoryName) {
    categoryFilter.value = categoryName;
    changeTab(1); // Navigate to list
  }

  void clearAllFilters() {
    filter.value = null;
    categoryFilter.value = null;
  }

  List<Complaint> get filteredComplaints {
    return complaints.where((c) {
      final statusMatch = filter.value == null || c.status == filter.value;
      final categoryMatch = categoryFilter.value == null ||
          c.complaintType == categoryFilter.value;
      return statusMatch && categoryMatch;
    }).toList();
  }

  // --- Add Complaint Logic ---

  void selectType(ComplaintType type) {
    selectedType.value = type;
    selectedSubComplaints.clear();
    issues.clear();
  }

  void toggleSubComplaint(SubComplaint sub) {
    if (selectedSubComplaints.contains(sub)) {
      selectedSubComplaints.remove(sub);
      issues.remove(sub.name);
    } else {
      selectedSubComplaints.add(sub);
    }
  }

  void updateIssueDescription(String key, String description) {
    final existing = issues[key] ?? ComplaintIssueData(description: '');
    issues[key] = ComplaintIssueData(
      description: description,
      imagePath: existing.imagePath,
    );
  }

  void updateIssueImage(String key, String? imagePath) {
    final existing = issues[key] ?? ComplaintIssueData(description: '');
    issues[key] = ComplaintIssueData(
      description: existing.description,
      imagePath: imagePath,
    );
  }

  Future<void> submitComplaint(BuildContext context) async {
    if (selectedType.value == null) return;

    UIController.to.showLoading();
    isLoading.value = true;
    try {
      // Collect issues
      final List<Map<String, dynamic>> issuesData = [];
      final hasSub = selectedType.value!.subComplaints.isNotEmpty;

      if (hasSub) {
        for (var sub in selectedSubComplaints) {
          final issue = issues[sub.name];
          if (issue != null) {
            issuesData.add({
              'sub_category': sub.name,
              'description': issue.description,
              'imagePath': issue.imagePath,
            });
          }
        }
      } else {
        final key = selectedType.value!.name;
        final issue = issues[key];
        if (issue != null) {
          issuesData.add({
            'description': issue.description,
            'imagePath': issue.imagePath,
          });
        }
      }

      final complaint = Complaint(
        id: '', // Backend generates ID
        dateTime: DateTime.now(),
        complaintType: selectedType.value!.name,
        issues: issues, // The repository will map this properly
        status: ComplaintStatus.pending,
      );

      await _repository.createComplaint(complaint);

      UIController.to.showSuccess('Complaint submitted successfully!');
      Get.back(); // Return to main screen

      fetchComplaints();
      fetchStats();
      resetAddDraft();
    } catch (e) {
      UIController.to.showError('Failed to submit complaint: $e');
    } finally {
      UIController.to.hideLoading();
      isLoading.value = false;
    }
  }

  void resetAddDraft() {
    selectedType.value = null;
    selectedSubComplaints.clear();
    issues.clear();
  }

  Future<void> updateStatus(String id, ComplaintStatus status) async {
    try {
      debugPrint('🔄 Updating complaint $id to ${status.toBackendString}');
      await _repository.updateComplaintStatus(id, status);
      debugPrint('✅ Status updated successfully');
      fetchComplaints(); // Refresh
      fetchStats();
    } catch (e) {
      UIController.to.showError('Failed to update status: $e');
    }
  }

  void changeTab(int index) {
    tabIndex.value = index;
  }
}
