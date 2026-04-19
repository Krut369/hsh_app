import 'package:get/get.dart';
import '../../features/complaint/add_complaint_screen.dart';
import '../../features/scanner/mobile_scanner_screen.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/chat/chat_details_screen.dart';
import '../../features/notes/notes_screen.dart';
import '../../features/holiday/holiday_screen.dart';
import '../../features/holiday/holiday_form.dart';
import '../../features/payment/payment_screen.dart';
import '../../features/services/all_services_screen.dart';
import '../../features/vehicle/vehicle_registration_screen.dart';
import '../../student_main_shell.dart';
import '../bindings/student_binding.dart';

class StudentRoutes {
  static const String shell = '/student';
  static const String profile = '/student/profile';
  static const String complaint = '/student/complaint';
  static const String addComplaint = '/student/complaint/add';
  static const String laundry = '/student/laundry';
  static const String attendance = '/student/attendance';
  static const String scanner = '/student/attendance/scanner';
  static const String chat = '/student/chat';
  static const String chatDetails = '/student/chat/details';
  static const String notes = '/student/notes';
  static const String holiday = '/student/holiday';
  static const String addHoliday = '/student/holiday/add';
  static const String payment = '/student/payment';
  static const String services = '/student/services-all';
  static const String vehicle = '/student/vehicle-registration';

  static final List<GetPage> pages = [
    GetPage(
      name: shell,
      page: () => const StudentMainShell(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addComplaint,
      page: () => const AddComplaintScreen(),
    ),
    GetPage(
      name: scanner,
      page: () => const AppScannerScreen(),
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: chatDetails,
      page: () => const ChatDetailsScreen(),
    ),
    GetPage(
      name: notes,
      page: () => const NotesScreen(),
    ),
    GetPage(
      name: holiday,
      page: () => const HolidayScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: addHoliday,
      page: () => const HolidayForm(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: payment,
      page: () => const PaymentScreen(),
      binding: StudentBinding(),
    ),
    GetPage(
      name: services,
      page: () => const AllServicesScreen(),
    ),
    GetPage(
      name: vehicle,
      page: () => const VehicleRegistrationScreen(),
    ),
  ];
}
