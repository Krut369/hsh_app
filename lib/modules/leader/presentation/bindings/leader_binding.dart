import 'package:get/get.dart';
import 'package:hsh_app/modules/leader/presentation/shell/controllers/shell_controller.dart';
import 'package:hsh_app/modules/leader/features/dashboard/presentation/controllers/leader_dashboard_controller.dart';
import 'package:hsh_app/modules/leader/features/attendance/presentation/controllers/attendance_controller.dart';
import 'package:hsh_app/modules/leader/features/chat/presentation/controllers/chat_controller.dart';
import 'package:hsh_app/modules/leader/features/leave_requests/presentation/controllers/leave_requests_controller.dart';
import 'package:hsh_app/modules/leader/features/student_results/presentation/controllers/student_results_controller.dart';

class LeaderBinding extends Bindings {
  @override
  void dependencies() {
    // Shell and Main Controllers
    Get.lazyPut<LeaderShellController>(() => LeaderShellController(), fenix: true);
    Get.lazyPut<LeaderDashboardController>(() => LeaderDashboardController(), fenix: true);

    // Feature Controllers
    Get.lazyPut<LeaderAttendanceController>(() => LeaderAttendanceController(), fenix: true);
    Get.lazyPut<HostelChatGroupsController>(() => HostelChatGroupsController(), fenix: true);
    Get.lazyPut<LeaveRequestsController>(() => LeaveRequestsController(), fenix: true);
    Get.lazyPut<StudentResultsController>(() => StudentResultsController(), fenix: true);
  }
}
