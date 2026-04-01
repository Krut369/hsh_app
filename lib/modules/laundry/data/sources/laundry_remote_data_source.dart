import 'package:hsh_app/modules/laundry/data/models/laundry_models.dart';
import 'package:hsh_app/services/service_provider.dart';

class LaundryRemoteDataSource {
  final _service = serviceProvider.laundry;

  /// Fetch laundry labels and orders
  /// GET /laundry
  Future<List<LaundryOrderModel>> getOrders() async {
    final response = await _service.getLaundryOrders();

    if (response.success && response.data != null) {
      final List<dynamic> list = (response.data is Map && response.data.containsKey('data'))
          ? (response.data['data'] as List<dynamic>)
          : (response.data is List ? response.data : []);
      return list.map((e) => LaundryOrderModel.fromJson(e)).toList();
    }
    return [];
  }

  /// Update laundry order status
  /// PATCH /laundry/:id/status
  Future<void> updateOrderStatus(String orderId, String status) async {
    final response = await _service.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update order status');
    }
  }

  /// Get pricing configuration
  /// GET /laundry/prices
  Future<LaundryCostModel> getLaundryCost() async {
    final response = await _service.getLaundryPrices();
    if (response.success && response.data != null) {
      final data = response.data is Map && response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return LaundryCostModel.fromJson(data);
    }
    throw Exception(response.message ?? 'Failed to fetch laundry prices');
  }

  /// Update pricing configuration
  /// PUT /laundry/prices
  Future<void> updateLaundryCost(LaundryCostModel cost) async {
    final response = await _service.updateLaundryPrices(cost.toJson());
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update laundry prices');
    }
  }

  /// Create a new laundry order
  /// POST /laundry
  Future<void> createOrder(Map<String, dynamic> body) async {
    final response = await _service.createLaundryOrder(
      serviceType: body['serviceType'],
      items: (body['items'] as List).cast<Map<String, dynamic>>(),
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to place laundry order');
    }
  }
}
