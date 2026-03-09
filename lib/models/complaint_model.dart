// Enum to define the current status of a complaint
enum ComplaintStatus {
  underReview,
  pending,
  awaitingFeedback,
  resolved,
}

// Extension to get user-friendly labels for each complaint status
extension ComplaintStatusExtension on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.underReview:
        return 'Under Review';
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.awaitingFeedback:
        return 'Awaiting Feedback';
      case ComplaintStatus.resolved:
        return 'Resolved';
    }
  }

  // Optional: Add color codes or icons based on status
  String get colorHex {
    switch (this) {
      case ComplaintStatus.underReview:
        return '#FFA500'; // Orange
      case ComplaintStatus.pending:
        return '#FF4C4C'; // Red
      case ComplaintStatus.awaitingFeedback:
        return '#1E90FF'; // Blue
      case ComplaintStatus.resolved:
        return '#28A745'; // Green
    }
  }

  // Backend string value
  String get toBackendString {
    switch (this) {
      case ComplaintStatus.underReview:
        return 'UNDER_REVIEW';
      case ComplaintStatus.pending:
        return 'PENDING';
      case ComplaintStatus.awaitingFeedback:
        return 'AWAITING_FEEDBACK';
      case ComplaintStatus.resolved:
        return 'RESOLVED';
    }
  }
}

// Represents a subcategory of a complaint (e.g., Fan under Electrical)
class SubComplaint {
  final String name;
  String description;

  SubComplaint({
    required this.name,
    this.description = '',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubComplaint && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

// Represents a complaint type category with its sub-complaints
class ComplaintType {
  final String name;
  final List<SubComplaint> subComplaints;

  ComplaintType({
    required this.name,
    required this.subComplaints,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ComplaintType && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;
}

// Represents the data for a specific valid complaint issue
class ComplaintIssueData {
  final String description;
  final String? imagePath;

  ComplaintIssueData({
    required this.description,
    this.imagePath,
  });

  factory ComplaintIssueData.fromJson(Map<String, dynamic> json) {
    return ComplaintIssueData(
      description: json['description'] ?? '',
      imagePath: json['imageUrl'] ?? json['image'] ?? json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'image': imagePath,
    };
  }
}

// Represents a user-submitted complaint
class Complaint {
  final String id;
  final DateTime dateTime;
  final String complaintType;
  final Map<String, ComplaintIssueData> issues; // SubComplaint name (or Type name) -> Issue Data
  final ComplaintStatus status;

  Complaint({
    required this.id,
    required this.dateTime,
    required this.complaintType,
    required this.issues,
    this.status = ComplaintStatus.pending,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    // Complaint Type from category object
    final categoryObj = json['category'];
    final String typeName = (categoryObj is Map) ? (categoryObj['name'] ?? 'General') : (json['complaintType'] ?? 'General');

    // Parse issues array from backend into Map structure used by frontend
    final issuesList = json['issues'] as List<dynamic>? ?? [];
    final issuesMap = <String, ComplaintIssueData>{};

    for (var issue in issuesList) {
      // Subcategory might be nested object
      final subCategoryObj = issue['subCategory'];
      final String? subCategoryName = (subCategoryObj is Map) ? subCategoryObj['name'] : null;
      
      // Use subCategory name as key if valid, else use complaintType
      final key = subCategoryName ?? typeName;
      
      issuesMap[key] = ComplaintIssueData.fromJson(issue);
    }
    
    // Status parsing
    ComplaintStatus status = ComplaintStatus.pending;
    try {
        final statusStr = json['status']?.toString().toUpperCase();
        if (statusStr == 'PENDING') status = ComplaintStatus.pending;
        else if (statusStr == 'UNDER_REVIEW') status = ComplaintStatus.underReview;
        else if (statusStr == 'AWAITING_FEEDBACK') status = ComplaintStatus.awaitingFeedback;
        else if (statusStr == 'RESOLVED') status = ComplaintStatus.resolved;
    } catch (_) {}

    return Complaint(
      id: json['id']?.toString() ?? '',
      dateTime: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      complaintType: typeName,
      issues: issuesMap,
      status: status,
    );
  }
}

// Predefined list of complaint types and subtypes
final List<ComplaintType> complaintTypes = [
  ComplaintType(
    name: 'Carpentry',
    subComplaints: [
      SubComplaint(name: 'Bed'),
      SubComplaint(name: 'Door'),
      SubComplaint(name: 'Cupboard'),
    ],
  ),
  ComplaintType(
    name: 'Electrical',
    subComplaints: [
      SubComplaint(name: 'Fan'),
      SubComplaint(name: 'Light'),
      SubComplaint(name: 'Geyser'),
      SubComplaint(name: 'Switch Board'),
    ],
  ),
  ComplaintType(
    name: 'Plumbing',
    subComplaints: [
      SubComplaint(name: 'Tap'),
      SubComplaint(name: 'Flush'),
      SubComplaint(name: 'Jet Spray'),
    ],
  ),
  ComplaintType(name: 'Housekeeping', subComplaints: []),
  ComplaintType(name: 'Construction', subComplaints: []),
  ComplaintType(name: 'Other', subComplaints: []),
];
