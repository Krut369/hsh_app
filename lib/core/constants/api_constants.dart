/// API Configuration Constants for HSH Management Backend V2.0.0
class ApiConstants {
  // ── Base URL (localhost for dev; swap to deployed URL for prod) ──────────
  static const String baseUrl = 'http://localhost:5000';

  // API mount path
  static const String apiVersion = '/api';

  // Full Base URL → http://localhost:5000/api
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // Static uploads base URL → http://localhost:5000/uploads/
  static String get uploadsBaseUrl => '$baseUrl/uploads/';

  // Timeout Duration
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ── Authentication Endpoints ─────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String authMe = '/auth/me';
  static const String authUsers = '/auth/users'; // Admin: provision accounts

  // ── Student Endpoints ────────────────────────────────────────────────────
  // NOTE: Student profile uses /:aadhar param — build URL dynamically in service
  static const String students = '/students';
  static const String studentsAdmin = '/students/admin';
  static const String studentsAdminApprove = '/students/admin/approve';
  static const String studentsAdminSwap = '/students/admin/swap';
  static const String studentsAdminLeft = '/students/admin/left';

  // ── Attendance Endpoints ─────────────────────────────────────────────────
  static const String attendance = '/attendance';
  static const String attendanceSabhas = '/attendance/sabhas';
  static const String attendanceDates = '/attendance/dates';
  static const String attendanceAdminSabhas = '/attendance/admin/sabhas';

  // ── Leave Endpoints ──────────────────────────────────────────────────────
  static const String leaves = '/leaves';
  // For admin approve/reject: PATCH /leaves/admin/:id  (build dynamically)
  static const String leavesAdmin = '/leaves/admin';

  // ── Fees / Finance Endpoints ─────────────────────────────────────────────
  static const String fees = '/fees';
  static const String feesSummary = '/fees/summary';
  static const String feesTransactions = '/fees/transactions';
  static const String feesDebits = '/fees/debits';
  static const String feesDeposits = '/fees/deposits';
  static const String feesAdminTransactions = '/fees/admin/transactions';
  static const String feesAdminDeposits = '/fees/admin/deposits';
  static const String feesAdminDebits = '/fees/admin/debits';

  // Legacy aliases (so existing payment controllers compile without changes)
  static const String payments = '/fees/transactions';
  static const String paymentsHistory = '/fees/transactions';
  static const String paymentsSummary = '/fees/summary';

  // ── Laundry Endpoints ────────────────────────────────────────────────────
  static const String laundry = '/laundry';
  static const String laundryBalance = '/laundry/balance';
  static const String laundryAdmin = '/laundry/admin';
  static const String laundryAdminRecharge = '/laundry/admin/recharge';

  // ── Complaint Endpoints (NOTE: /complains not /complaints) ───────────────
  static const String complains = '/complains';
  static const String complainsCategories = '/complains/categories';
  // Image URL pattern: /uploads/complains/complain_{id}_{index}.{ext}
  static String complainImageUrl(int id, int index, String ext) =>
      '${uploadsBaseUrl}complains/complain_${id}_$index.$ext';

  // ── Vehicle Endpoints ───────────────────────────────────────────────────
  static const String vehicleRegister = '/vehicles';
  static const String vehicleStatus = '/vehicles/status';

  // ── Notes Endpoints ──────────────────────────────────────────────────────
  static const String notes = '/notes';

  // ── Chat Endpoints ───────────────────────────────────────────────────────
  static const String chatGroups = '/chat/groups';
  static const String chatMessages = '/chat/messages';

  // ── Headers ──────────────────────────────────────────────────────────────
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';

  // ── Storage Keys ─────────────────────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String aadharKey = 'student_aadhar'; // cached after bootstrap
}
