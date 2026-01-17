import 'dart:convert';

enum VehicleStatus {
  pending,
  approved,
  rejected,
}

class VehicleRequest {
  final String id;
  final String studentId;
  final String vehicleType;
  final String plateNumber;
  final String modelMake;
  final String parkingPreference;
  final String? registrationPapersUrl;
  final VehicleStatus status;
  final DateTime createdAt;

  const VehicleRequest({
    required this.id,
    required this.studentId,
    required this.vehicleType,
    required this.plateNumber,
    required this.modelMake,
    required this.parkingPreference,
    this.registrationPapersUrl,
    required this.status,
    required this.createdAt,
  });

  VehicleRequest copyWith({
    String? id,
    String? studentId,
    String? vehicleType,
    String? plateNumber,
    String? modelMake,
    String? parkingPreference,
    String? registrationPapersUrl,
    VehicleStatus? status,
    DateTime? createdAt,
  }) {
    return VehicleRequest(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      vehicleType: vehicleType ?? this.vehicleType,
      plateNumber: plateNumber ?? this.plateNumber,
      modelMake: modelMake ?? this.modelMake,
      parkingPreference: parkingPreference ?? this.parkingPreference,
      registrationPapersUrl:
          registrationPapersUrl ?? this.registrationPapersUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'vehicleType': vehicleType,
      'plateNumber': plateNumber,
      'modelMake': modelMake,
      'parkingPreference': parkingPreference,
      'registrationPapersUrl': registrationPapersUrl,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory VehicleRequest.fromMap(Map<String, dynamic> map) {
    return VehicleRequest(
      id: map['id']?.toString() ?? '',
      studentId: map['studentId']?.toString() ?? '',
      vehicleType: map['vehicleType']?.toString() ?? '',
      plateNumber: map['plateNumber']?.toString() ?? '',
      modelMake: map['modelMake']?.toString() ?? '',
      parkingPreference: map['parkingPreference']?.toString() ?? '',
      registrationPapersUrl: map['registrationPapersUrl']?.toString(),
      status: VehicleStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => VehicleStatus.pending,
      ),
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  factory VehicleRequest.fromJson(String source) =>
      VehicleRequest.fromMap(json.decode(source));

  @override
  String toString() {
    return 'VehicleRequest(id: $id, studentId: $studentId, vehicleType: $vehicleType, plateNumber: $plateNumber, modelMake: $modelMake, parkingPreference: $parkingPreference, registrationPapersUrl: $registrationPapersUrl, status: $status, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VehicleRequest &&
        other.id == id &&
        other.studentId == studentId &&
        other.vehicleType == vehicleType &&
        other.plateNumber == plateNumber &&
        other.modelMake == modelMake &&
        other.parkingPreference == parkingPreference &&
        other.registrationPapersUrl == registrationPapersUrl &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        studentId.hashCode ^
        vehicleType.hashCode ^
        plateNumber.hashCode ^
        modelMake.hashCode ^
        parkingPreference.hashCode ^
        registrationPapersUrl.hashCode ^
        status.hashCode ^
        createdAt.hashCode;
  }
}
