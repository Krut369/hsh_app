import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Laundry Service
class LaundryService {
  final ApiClient _apiClient;

  LaundryService(this._apiClient);

  /// Get laundry orders history
  /// GET /laundry
  Future<ApiResponse> getLaundryOrders({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.laundry,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Create laundry order
  /// POST /laundry
  Future<ApiResponse> createLaundryOrder({
    required String serviceType,
    required List<Map<String, dynamic>> items,
  }) async {
    return await _apiClient.post(
      ApiConstants.laundry,
      body: {
        'serviceType': serviceType,
        'items': items,
      },
    );
  }

  /// Update laundry order status (Laundry role only)
  /// PATCH /laundry/:id/status
  Future<ApiResponse> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.laundry}/$orderId/status',
      body: {'status': status},
    );
  }

  /// Fetch laundry pricing configuration
  /// GET /laundry/prices
  Future<ApiResponse> getLaundryPrices() async {
    return await _apiClient.get(ApiConstants.laundryPrices);
  }

  /// Update laundry pricing configuration (Admin only)
  /// PUT /laundry/prices
  Future<ApiResponse> updateLaundryPrices(Map<String, dynamic> body) async {
    return await _apiClient.put(
      ApiConstants.laundryPrices,
      body: body,
    );
  }

  /// Get laundry stats
  Future<ApiResponse> getLaundryStats() async {
    return await _apiClient.get(ApiConstants.laundryStats);
  }
}
