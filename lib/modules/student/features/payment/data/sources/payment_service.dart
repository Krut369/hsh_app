import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';

/// Fees / Finance Service — V2.0.0 API (/api/fees)
/// Student's Aadhar is auto-resolved from JWT token by the server.
class PaymentService {
  final ApiClient _apiClient;

  PaymentService(this._apiClient);

  // ── Student endpoints (aadhar auto-resolved from JWT) ────────────────────

  /// Get fee summary & balance
  /// GET /fees/summary
  /// Also returns `aadhar` — cache this for student profile fetch!
  Future<ApiResponse> getFeeSummary() async {
    return await _apiClient.get(ApiConstants.feesSummary);
  }

  /// Submit a payment transaction
  /// POST /fees/transactions
  Future<ApiResponse> submitTransaction({
    required double amount,
    required String paymentType, // 'online' | 'cheque' | 'cash'
    String? bankName,
    String? narration,
    String? chequeNumber, // Required if paymentType == 'cheque'
    String? chequeDate, // ISO-8601 UTC string
  }) async {
    return await _apiClient.post(
      ApiConstants.feesTransactions,
      body: {
        'amount': amount,
        'paymentType': paymentType,
        if (bankName != null) 'bankName': bankName,
        if (narration != null) 'narration': narration,
        if (chequeNumber != null) 'chequeNumber': chequeNumber,
        if (chequeDate != null) 'chequeDate': chequeDate,
      },
    );
  }

  /// Get payment transactions
  /// GET /fees/transactions
  Future<ApiResponse> getTransactions({
    String? status, // 'pending' | 'approved' | 'rejected'
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (status != null) queryParams['status'] = status;

    return await _apiClient.get(
      ApiConstants.feesTransactions,
      queryParameters: queryParams,
    );
  }

  /// Get fee debits (billed items)
  /// GET /fees/debits
  Future<ApiResponse> getFeeDebits({
    int? year,
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (year != null) queryParams['year'] = year;

    return await _apiClient.get(
      ApiConstants.feesDebits,
      queryParameters: queryParams,
    );
  }

  /// Get security deposits
  /// GET /fees/deposits
  Future<ApiResponse> getDeposits({
    int? year,
    int limit = 100,
    int offset = 0,
  }) async {
    final queryParams = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (year != null) queryParams['year'] = year;

    return await _apiClient.get(
      ApiConstants.feesDeposits,
      queryParameters: queryParams,
    );
  }

  // ── Admin endpoints ──────────────────────────────────────────────────────

  /// Admin: approve or reject a payment transaction
  /// PATCH /fees/admin/transactions/:id
  Future<ApiResponse> updateTransactionStatus({
    required int id,
    required String status, // 'approved' | 'rejected'
  }) async {
    return await _apiClient.patch(
      '${ApiConstants.feesAdminTransactions}/$id',
      body: {'status': status},
    );
  }

  /// Admin: record a deposit credit/debit
  /// POST /fees/admin/deposits
  Future<ApiResponse> createDeposit(Map<String, dynamic> body) async {
    return await _apiClient.post(ApiConstants.feesAdminDeposits, body: body);
  }

  /// Admin: debit student fee balance
  /// POST /fees/admin/debits
  Future<ApiResponse> createDebit(Map<String, dynamic> body) async {
    return await _apiClient.post(ApiConstants.feesAdminDebits, body: body);
  }

  // ── Backward compatibility aliases for PaymentController ──────────────────

  /// Alias for getTransactions()
  Future<ApiResponse> getPaymentHistory() async => getTransactions();

  /// Alias for submitTransaction(...)
  Future<ApiResponse> initiatePayment({
    required double amount,
    String? type,
    String? remark,
  }) async {
    return submitTransaction(
      amount: amount,
      paymentType: type ?? 'online',
      narration: remark,
    );
  }
}
