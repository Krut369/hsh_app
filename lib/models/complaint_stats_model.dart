class ComplaintStats {
  final int total;
  final int pending;
  final int resolved;
  final int inProgress;

  ComplaintStats({
    required this.total,
    required this.pending,
    required this.resolved,
    required this.inProgress,
  });

  factory ComplaintStats.fromJson(Map<String, dynamic> json) {
    return ComplaintStats(
      total: json['total'] ?? 0,
      pending: json['pending'] ?? 0,
      resolved: json['resolved'] ?? 0,
      inProgress: json['in_progress'] ?? 0,
    );
  }

  factory ComplaintStats.empty() {
    return ComplaintStats(
      total: 0,
      pending: 0,
      resolved: 0,
      inProgress: 0,
    );
  }
}
