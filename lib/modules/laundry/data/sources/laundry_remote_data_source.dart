import 'package:hsh_app/modules/laundry/data/models/laundry_models.dart';
import 'package:hsh_app/services/service_provider.dart';

/// Laundry Remote Data Source — V2.0.0 API
class LaundryRemoteDataSource {
  final _service = serviceProvider.laundry;

  /// Get prepaid laundry balance
  /// GET /laundry/balance
  Future<Map<String, dynamic>> getBalance() async {
    final response = await _service.getLaundryBalance();
    if (response.success && response.data != null) {
      final data = response.data;
      if (data is Map) {
        final inner = data['data'] ?? data;
        if (inner is Map) {
          return (inner['balance'] ?? inner) as Map<String, dynamic>;
        }
      }
    }
    throw Exception(response.message ?? 'Failed to fetch laundry balance');
  }

  /// Fetch laundry tickets
  /// GET /laundry
  Future<List<LaundryOrderModel>> getOrders({String? status}) async {
    final response = await _service.getLaundryOrders(status: status);

    if (response.success && response.data != null) {
      final data = response.data;
      List<dynamic> list = [];
      if (data is Map) {
        final inner = data['data'] ?? data;
        if (inner is Map) {
          list = (inner['laundry'] ?? inner['data'] ?? []) as List<dynamic>;
        } else if (inner is List) {
          list = inner;
        }
      } else if (data is List) {
        list = data;
      }
      return list
          .map((e) => LaundryOrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get single ticket details
  /// GET /laundry/:id
  Future<LaundryOrderModel> getTicket(int id) async {
    final response = await _service.getLaundryTicket(id);
    if (response.success && response.data != null) {
      final data = response.data;
      if (data is Map) {
        final inner = data['data'] ?? data;
        if (inner is Map) {
          final ticket = inner['laundry'] ?? inner;
          return LaundryOrderModel.fromJson(ticket as Map<String, dynamic>);
        }
      }
    }
    throw Exception(response.message ?? 'Failed to fetch ticket');
  }

  /// Update laundry ticket status (admin)
  /// PATCH /laundry/admin/:id
  Future<void> updateOrderStatus(int id, String status) async {
    final response = await _service.updateOrderStatus(id: id, status: status);
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to update order status');
    }
  }

  /// Submit a new laundry ticket
  /// POST /laundry
  Future<void> createOrder(Map<String, dynamic> garments) async {
    final response = await _service.submitLaundryTicket(
      pants: garments['pants'] ?? 0,
      pressPants: garments['pressPants'] ?? 0,
      shirts: garments['shirts'] ?? 0,
      pressShirts: garments['pressShirts'] ?? 0,
      tShirts: garments['tShirts'] ?? 0,
      pressTShirts: garments['pressTShirts'] ?? 0,
      towels: garments['towels'] ?? 0,
      pressTowels: garments['pressTowels'] ?? 0,
      blanket: garments['blanket'] ?? 0,
      jacket: garments['jacket'] ?? 0,
      bedSheet: garments['bedSheet'] ?? 0,
      others: garments['others'] ?? 0,
      pressOthers: garments['pressOthers'] ?? 0,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Failed to place laundry order');
    }
  }

  // ── Backward compatibility methods for LaundryRepository ────────────────

  Future<LaundryCostModel> getLaundryCost() async {
    return LaundryCostModel(washPrice: 10.0, pressPrice: 5.0, bothPrice: 15.0);
  }

  Future<void> updateLaundryCost(LaundryCostModel cost) async {}
}
