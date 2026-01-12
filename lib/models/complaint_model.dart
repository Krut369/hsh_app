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
}

// Represents a user-submitted complaint
class Complaint {
  final String id;
  final DateTime dateTime;
  final String complaintType;
  final Map<String, ComplaintIssueData> issues; // SubComplaint name (or Type name) → Issue Data
  ComplaintStatus status;

  Complaint({
    required this.id,
    required this.dateTime,
    required this.complaintType,
    required this.issues,
    this.status = ComplaintStatus.pending,
  });
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
