import '../core/network/api_client.dart';
import 'auth_service.dart';
import 'student_service.dart';
import 'laundry_service.dart';
import 'complaint_service.dart';
import 'attendance_service.dart';
import 'vehicle_service.dart';
import 'holiday_service.dart';
import 'notes_service.dart';
import 'payment_service.dart';
import 'chat_service.dart';

/// Service Provider - Centralized access to all API services
class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  factory ServiceProvider() => _instance;
  ServiceProvider._internal();

  // API Client
  final ApiClient _apiClient = ApiClient();

  // Services
  late final AuthService auth = AuthService(_apiClient);
  late final StudentService student = StudentService(_apiClient);
  late final LaundryService laundry = LaundryService(_apiClient);
  late final ComplaintService complaint = ComplaintService(_apiClient);
  late final AttendanceService attendance = AttendanceService(_apiClient);
  late final VehicleService vehicle = VehicleService(_apiClient);
  late final HolidayService holiday = HolidayService(_apiClient);
  late final NotesService notes = NotesService(_apiClient);
  late final PaymentService payment = PaymentService(_apiClient);
  late final ChatService chat = ChatService(_apiClient);

  /// Get API Client instance
  ApiClient get apiClient => _apiClient;

  /// Dispose resources
  void dispose() {
    _apiClient.close();
  }
}

// Global instance for easy access
final serviceProvider = ServiceProvider();
