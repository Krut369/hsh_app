import 'package:go_router/go_router.dart';
import 'package:hsh_app/modules/leader/leader_main_shell.dart';
import 'package:hsh_app/modules/leader/features/attendance/attendance_main_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/group_chat_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/create_new_group_screen.dart';

import 'package:hsh_app/models/chat_group_model.dart';
import 'package:hsh_app/modules/leader/features/student_results/student_results_screen.dart';
import 'package:hsh_app/modules/leader/features/leave_requests/leave_requests_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/hostel_chat_groups_screen.dart';

class LeaderRoutes {
  static const String main = '/leader';
  static const String attendance = 'attendance';
  static const String chatMessages = 'chat/messages';
  static const String chatCreate = 'chat/create';

  static const String leaveRequests = 'leave-requests';
  static const String studentResults = 'student-results';
  static const String chatGroups = 'chat-groups';

  static final List<RouteBase> routes = [
    GoRoute(
      path: main,
      builder: (context, state) => const LeaderMainShell(),
      routes: [
        GoRoute(
          path: attendance,
          builder: (context, state) => const AttendanceMainScreen(),
        ),
        GoRoute(
          path: leaveRequests,
          builder: (context, state) => const LeaveRequestsScreen(),
        ),
        GoRoute(
          path: studentResults,
          builder: (context, state) => const StudentResultsScreen(),
        ),
        GoRoute(
          path: chatGroups,
          builder: (context, state) => const HostelChatGroupsScreen(),
        ),
        GoRoute(
          path: chatMessages,
          builder: (context, state) {
            final group = state.extra as ChatGroup;
            return GroupChatScreen(group: group);
          },
        ),
        GoRoute(
          path: chatCreate,
          builder: (context, state) => const CreateNewGroupScreen(),
        ),

      ],
    ),
  ];
}
