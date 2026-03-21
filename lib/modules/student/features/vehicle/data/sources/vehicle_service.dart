import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Vehicle Service
class VehicleService {
  final ApiClient _apiClient;

  VehicleService(this._apiClient);

  /// Register vehicle
  Future<ApiResponse> registerVehicle({
    required String vehicleType,
    required String plateNumber,
    required String modelMake,
    required String parkingPreference,
    String? documentUrl,
  }) async {
    return await _apiClient.post(
      ApiConstants.vehicleRegister,
      body: {
        'vehicle_type': vehicleType,
        'plate_number': plateNumber,
        'model_make': modelMake,
        'parking_preference': parkingPreference,
        if (documentUrl != null) 'document_url': documentUrl,
      },
    );
  }

  /// Get vehicle registration status
  Future<ApiResponse> getVehicleStatus() async {
    return await _apiClient.get(ApiConstants.vehicleStatus);
  }

  /// Get all vehicle registrations (for admin)
  Future<ApiResponse> getAllVehicles({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.vehicleRegister,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Update vehicle registration status (Admin only)
  Future<ApiResponse> updateVehicleStatus({
    required String vehicleId,
    required String status,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.vehicleRegister}/$vehicleId/status',
      body: {'status': status},
    );
  }
}
