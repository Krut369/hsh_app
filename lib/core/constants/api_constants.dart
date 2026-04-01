/// API Configuration Constants
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://hsh-backend.onrender.com';

  // API Version
  static const String apiVersion = '/api/v1';

  // Full Base URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';

  // Timeout Duration
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // Student Endpoints
  static const String studentProfile = '/student/profile';

  // Attendance Endpoints
  static const String attendance = '/attendance';
  static const String attendanceMark = '/attendance/mark';
  static const String attendanceHistory = '/attendance/history';
  static const String attendanceStats = '/attendance/stats';

  // Vehicle Endpoints
  static const String vehicleRegister = '/vehicle/register';
  static const String vehicleStatus = '/vehicle/status';

  // Notes Endpoints
  static const String notes = '/notes';

  // Payments Endpoints
  static const String payments = '/payments';
  static const String paymentsHistory = '/payments/history';
  static const String paymentsSummary = '/payments/summary';

  // Laundry Endpoints
  static const String laundry = '/laundry';
  static const String laundryOrders = '/laundry';      // Updated to match backend
  static const String laundryPrices = '/laundry/prices';
  static const String laundryItems = '/laundry/items';
  static const String laundryConfig = '/laundry/config';
  static const String laundryStats = '/laundry/stats';

  // Complaint Endpoints
  static const String complaints = '/complaints';
  static const String complaintStats = '/complaints/stats';
  static const String upload = '/upload';

  // Holiday Endpoints
  static const String holidays = '/holidays';
  static const String holidayList = '/holidays/list';
  static const String holidayRequest = '/holidays/request';

  // Chat Endpoints
  static const String chatGroups = '/chat/groups';
  static const String chatMessages = '/chat/messages';

  // Headers
  static const String contentTypeJson = 'application/json';
  static const String contentTypeMultipart = 'multipart/form-data';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String refreshTokenKey = 'refresh_token';
}
