/// V2.0.0 complaint statuses: pending | resolved | reviewed
/// underReview maps to V2 backend "reviewed" status.
enum ComplaintStatus {
  pending,
  underReview,
  awaitingFeedback,
  resolved,
}

extension ComplaintStatusExtension on ComplaintStatus {
  String get label {
    switch (this) {
      case ComplaintStatus.pending:
        return 'Pending';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.underReview:
        return 'Under Review';
      case ComplaintStatus.awaitingFeedback:
        return 'Awaiting Feedback';
    }
  }

  String get colorHex {
    switch (this) {
      case ComplaintStatus.pending:
        return '#FF9800'; // Orange
      case ComplaintStatus.resolved:
        return '#4CAF50'; // Green
      case ComplaintStatus.underReview:
      case ComplaintStatus.awaitingFeedback:
        return '#2196F3'; // Blue
    }
  }

  String get toBackendString {
    switch (this) {
      case ComplaintStatus.pending:
        return 'pending';
      case ComplaintStatus.resolved:
        return 'resolved';
      case ComplaintStatus.underReview:
      case ComplaintStatus.awaitingFeedback:
        return 'reviewed';
    }
  }

  static ComplaintStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'resolved':
        return ComplaintStatus.resolved;
      case 'reviewed':
      case 'underreview':
        return ComplaintStatus.underReview;
      case 'awaitingfeedback':
        return ComplaintStatus.awaitingFeedback;
      default:
        return ComplaintStatus.pending;
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

/// V2.0.0 complaint record
class Complaint {
  final String id;
  final String? room;
  final String? aadhar;
  final String compType; // Category e.g. "Electrical"
  final String compDesc;
  final ComplaintStatus status;
  final int imageCount; // Number of uploaded images
  final DateTime? submitTime;
  final DateTime? resolvedAt;
  final String? staffResponse;

  /// Issues map kept for backward compatibility with UI components
  /// Key = compType, Value = ComplaintIssueData with compDesc
  Map<String, ComplaintIssueData> get issues => {
        compType: ComplaintIssueData(description: compDesc),
      };

  String get complaintType => compType;

  Complaint({
    required this.id,
    this.room,
    this.aadhar,
    String? compType,
    String? compDesc,
    String? complaintType,
    Map<String, ComplaintIssueData>? issues,
    this.status = ComplaintStatus.pending,
    this.imageCount = 0,
    DateTime? submitTime,
    DateTime? dateTime,
    this.resolvedAt,
    this.staffResponse,
  })  : compType = compType ??
            complaintType ??
            (issues != null && issues.isNotEmpty ? issues.keys.first : 'General'),
        compDesc = compDesc ??
            (issues != null && issues.isNotEmpty
                ? issues.values.first.description
                : ''),
        submitTime = submitTime ?? dateTime;

  DateTime get dateTime => submitTime ?? DateTime.now();

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id']?.toString() ?? '',
      room: json['room'] as String?,
      aadhar: json['aadhar'] as String?,
      compType: json['compType'] as String? ?? 'General',
      compDesc: json['compDesc'] as String? ?? '',
      status: ComplaintStatusExtension.fromString(json['status'] as String?),
      imageCount: (json['images'] as num?)?.toInt() ?? 0,
      submitTime: json['submitTime'] != null
          ? DateTime.tryParse(json['submitTime'] as String)
          : null,
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.tryParse(json['resolvedAt'] as String)
          : null,
      staffResponse: json['response'] as String?,
    );
  }

  /// Build image URL for a given index
  /// Pattern: /uploads/complains/complain_{id}_{index}.jpg
  String imageUrl(int index, {String ext = 'jpg'}) {
    final intId = int.tryParse(id) ?? 0;
    return 'http://localhost:5000/uploads/complains/complain_${intId}_$index.$ext';
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
