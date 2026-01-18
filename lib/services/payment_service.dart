import '../../core/network/api_client.dart';
import '../../core/constants/api_constants.dart';

/// Payment Service
class PaymentService {
  final ApiClient _apiClient;

  PaymentService(this._apiClient);

  /// Get payment history
  Future<ApiResponse> getPaymentHistory({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (startDate != null) queryParams['start_date'] = startDate.toIso8601String();
    if (endDate != null) queryParams['end_date'] = endDate.toIso8601String();
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.paymentsHistory,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }

  /// Get payment summary
  Future<ApiResponse> getPaymentSummary() async {
    return await _apiClient.get(ApiConstants.paymentsSummary);
  }

  /// Get single payment by ID
  Future<ApiResponse> getPaymentById(String paymentId) async {
    return await _apiClient.get('${ApiConstants.paymentsHistory}/$paymentId');
  }

  /// Create a payment (initiate transaction)
  Future<ApiResponse> createPayment({
    required String title,
    required double amount,
    required String method,
  }) async {
    return await _apiClient.post(
      ApiConstants.paymentsHistory,
      body: {
        'title': title,
        'amount': amount,
        'method': method,
      },
    );
  }

  /// Update payment status (Admin only)
  Future<ApiResponse> updatePaymentStatus({
    required String paymentId,
    required String status,
    String? transactionId,
  }) async {
    return await _apiClient.put(
      '${ApiConstants.paymentsHistory}/$paymentId/status',
      body: {
        'status': status,
        if (transactionId != null) 'transaction_id': transactionId,
      },
    );
  }
}
