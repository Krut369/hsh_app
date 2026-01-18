import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Laundry Service
class LaundryService {
  final ApiClient _apiClient;

  LaundryService(this._apiClient);

  /// Create a new laundry order
  Future<ApiResponse> createOrder({
    required List<Map<String, dynamic>> items,
    required String serviceType,
    String? note,
  }) async {
    return await _apiClient.post(
      ApiConstants.laundryOrders,
      body: {
        'items': items,
        'service_type': serviceType,
        if (note != null) 'note': note,
      },
    );
  }

  /// Get laundry orders
  /// For students: returns own orders
  /// For laundry staff: returns all orders
  Future<ApiResponse> getOrders({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (status != null) queryParams['status'] = status;
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();

    return await _apiClient.get(
      ApiConstants.laundryOrders,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get single order by ID
  Future<ApiResponse> getOrderById(String orderId) async {
    return await _apiClient.get('${ApiConstants.laundryOrders}/$orderId');
  }

  /// Update order status (Laundry staff only)
  Future<ApiResponse> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.laundryOrders}/$orderId/status',
      body: {'status': status},
    );
  }

  /// Get available laundry items
  Future<ApiResponse> getItems() async {
    return await _apiClient.get(ApiConstants.laundryItems);
  }

  /// Get laundry pricing configuration
  Future<ApiResponse> getConfig() async {
    return await _apiClient.get(ApiConstants.laundryConfig);
  }

  /// Update laundry pricing (Admin/Laundry only)
  Future<ApiResponse> updateConfig({
    required Map<String, dynamic> prices,
  }) async {
    return await _apiClient.put(
      ApiConstants.laundryConfig,
      body: prices,
    );
  }
}
