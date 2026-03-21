import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Payment Service
class PaymentService {
  final ApiClient _apiClient;

  PaymentService(this._apiClient);

  /// Get student payment history
  Future<ApiResponse> getPaymentHistory() async {
    return await _apiClient.get(ApiConstants.payments);
  }

  /// Initiate payment
  Future<ApiResponse> initiatePayment({
    required double amount,
    required String type,
    String? remark,
  }) async {
    return await _apiClient.post(
      ApiConstants.payments,
      body: {
        'amount': amount,
        'type': type,
        'remark': remark,
      },
    );
  }

  /// Verify payment status
  Future<ApiResponse> verifyPayment(String transactionId) async {
    return await _apiClient
        .get('${ApiConstants.payments}/$transactionId/verify');
  }

  /// Get pending dues
  Future<ApiResponse> getPendingDues() async {
    return await _apiClient.get('${ApiConstants.payments}/dues');
  }

  /// Get all payments (Admin)
  Future<ApiResponse> getAllPayments({String? status}) async {
    final queryParams = <String, dynamic>{};
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.payments,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );
  }
}
