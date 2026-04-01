import 'package:hsh_app/modules/laundry/data/models/laundry_models.dart';
import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

class LaundryRemoteDataSource {
  final ApiClient _apiClient;

  LaundryRemoteDataSource(this._apiClient);

  Future<List<LaundryOrderModel>> getOrders() async {
    final response = await _apiClient.get(ApiConstants.laundryOrders);
    
    if (response.success && response.data != null) {
      final body = response.data;
      final List<dynamic> data = body is Map ? (body['data'] ?? []) : body;
      return data.map((item) => LaundryOrderModel.fromJson(item)).toList();
    } else {
      throw Exception(response.message ?? 'Failed to fetch laundry orders');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await _apiClient.patch(
      '${ApiConstants.laundryOrders}/$orderId/status',
      body: {'status': status},
    );
    
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update order status');
    }
  }

  Future<LaundryCostModel> getLaundryCost() async {
    final response = await _apiClient.get(ApiConstants.laundryConfig);
    
    if (response.success && response.data != null) {
      final body = response.data;
      final data = body is Map ? (body['data'] ?? body) : body;
      return LaundryCostModel.fromJson(data);
    } else {
      throw Exception(response.message ?? 'Failed to fetch laundry cost config');
    }
  }

  Future<void> updateLaundryCost(LaundryCostModel cost) async {
    final response = await _apiClient.put(
      ApiConstants.laundryConfig,
      body: cost.toJson(),
    );
    
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update laundry cost');
    }
  }
}
