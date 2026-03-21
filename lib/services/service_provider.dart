import 'package:hsh_app/core/network/api_client.dart';
import 'package:hsh_app/core/constants/api_constants.dart';
import 'package:hsh_app/modules/laundry/data/sources/laundry_service.dart';
import 'package:hsh_app/modules/complain/data/sources/complaint_service.dart';
import 'package:hsh_app/modules/student/features/attendance/data/sources/attendance_service.dart';
import 'package:hsh_app/modules/student/features/vehicle/data/sources/vehicle_service.dart';
import 'package:hsh_app/modules/student/features/holiday/data/sources/holiday_service.dart';
import 'package:hsh_app/modules/student/features/notes/data/sources/notes_service.dart';
import 'package:hsh_app/modules/student/features/payment/data/sources/payment_service.dart';
import 'package:hsh_app/modules/chat/data/sources/chat_service.dart';
import 'package:hsh_app/modules/student/data/sources/student_service.dart';

/// Service Provider - Centralized access to all API services
class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  factory ServiceProvider() => _instance;
  ServiceProvider._internal();

  // API Client
  final ApiClient _apiClient = ApiClient();

  // Services
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
