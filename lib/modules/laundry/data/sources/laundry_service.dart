import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Laundry Service — V2.0.0 API (/api/laundry)
/// Aadhar auto-resolved from JWT for students.
/// Items submitted as individual garment counts.
class LaundryService {
  final ApiClient _apiClient;

  LaundryService(this._apiClient);

  // ── Student endpoints ────────────────────────────────────────────────────

  /// Get prepaid laundry balance
  /// GET /laundry/balance
  /// Also returns aadhar — useful for dashboard bootstrap.
  Future<ApiResponse> getLaundryBalance() async {
    return await _apiClient.get(ApiConstants.laundryBalance);
  }

  /// Submit a laundry ticket
  /// POST /laundry
  /// All garment counts default to 0 if omitted.
  Future<ApiResponse> submitLaundryTicket({
    int pants = 0,
    int pressPants = 0,
    int shirts = 0,
    int pressShirts = 0,
    int tShirts = 0,
    int pressTShirts = 0,
    int towels = 0,
    int pressTowels = 0,
    int blanket = 0,
    int jacket = 0,
    int bedSheet = 0,
    int others = 0,
    int pressOthers = 0,
  }) async {
    return await _apiClient.post(
      ApiConstants.laundry,
      body: {
        'pants': pants,
        'pressPants': pressPants,
        'shirts': shirts,
        'pressShirts': pressShirts,
        'tShirts': tShirts,
        'pressTShirts': pressTShirts,
        'towels': towels,
        'pressTowels': pressTowels,
        'blanket': blanket,
        'jacket': jacket,
        'bedSheet': bedSheet,
        'others': others,
        'pressOthers': pressOthers,
      },
    );
  }

  /// List laundry tickets
  /// GET /laundry
  Future<ApiResponse> getLaundryOrders({
    String? status, // 'pending' | 'accepted' | 'washed' | 'received'
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.laundry,
      queryParameters: queryParams,
    );
  }

  /// Get a single laundry ticket with full breakdown
  /// GET /laundry/:id
  Future<ApiResponse> getLaundryTicket(int id) async {
    return await _apiClient.get('${ApiConstants.laundry}/$id');
  }

  // ── Admin / Staff endpoints ──────────────────────────────────────────────

  /// Update laundry ticket status
  /// PATCH /laundry/admin/:id
  Future<ApiResponse> updateOrderStatus({
    required int id,
    required String status, // 'accepted' | 'washed' | 'received'
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.laundryAdmin}/$id',
      body: {'status': status},
    );
  }

  /// Top up student prepaid laundry balance
  /// POST /laundry/admin/recharge
  Future<ApiResponse> rechargeBalance({
    required String aadhar,
    required double amount,
  }) async {
    return await _apiClient.post(
      ApiConstants.laundryAdminRecharge,
      body: {
        'aadhar': aadhar,
        'amount': amount,
      },
    );
  }
}
