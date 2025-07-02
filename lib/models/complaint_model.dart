class ComplaintType {
  final String name;
  final List<SubComplaint> subComplaints;

  ComplaintType({
    required this.name,
    required this.subComplaints,
  });
}

class SubComplaint {
  final String name;
  String description;

  SubComplaint({
    required this.name,
    this.description = '',
  });
}

class Complaint {
  final String id;
  final DateTime dateTime;
  final String complaintType;
  final Map<String, String> descriptions;
  final String status;

  Complaint({
    required this.id,
    required this.dateTime,
    required this.complaintType,
    required this.descriptions,
    this.status = 'Pending',
  });
}

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
  ComplaintType(
    name: 'Housekeeping',
    subComplaints: [],
  ),
  ComplaintType(
    name: 'Construction',
    subComplaints: [],
  ),
  ComplaintType(
    name: 'Other',
    subComplaints: [],
  ),
];