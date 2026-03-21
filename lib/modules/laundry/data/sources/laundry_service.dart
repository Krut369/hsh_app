import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Laundry Service
class LaundryService {
  final ApiClient _apiClient;

  LaundryService(this._apiClient);

  /// Get laundry stats
  Future<ApiResponse> getLaundryStats() async {
    return await _apiClient.get(ApiConstants.laundryStats);
  }

  /// Get laundry orders
  Future<ApiResponse> getLaundryOrders({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.laundryOrders,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Create laundry order
  Future<ApiResponse> createLaundryOrder({
    required List<Map<String, dynamic>> items,
    required String pickupDate,
  }) async {
    return await _apiClient.post(
      ApiConstants.laundryOrders,
      body: {
        'items': items,
        'pickup_date': pickupDate,
      },
    );
  }

  /// Update laundry order status (Laundry role only)
  Future<ApiResponse> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.laundryOrders}/$orderId/status',
      body: {'status': status},
    );
  }
}
