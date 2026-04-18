import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:hsh_app/models/chat_group_model.dart';
import 'package:hsh_app/models/student_result_model.dart';
import 'package:hsh_app/modules/leader/features/student_results/presentation/screens/performance_insights_screen.dart';
import '../shell/leader_main_shell.dart';
import '../../features/dashboard/presentation/screens/leader_dashboard_screen.dart';
import '../../features/leave_requests/presentation/screens/leave_requests_screen.dart';
import '../../features/student_results/presentation/screens/student_results_screen.dart';
import '../../features/chat/presentation/screens/hostel_chat_groups_screen.dart';
import '../../features/attendance/presentation/screens/attendance_main_screen.dart';
import '../../features/chat/presentation/screens/group_chat_screen.dart';
import '../../features/chat/presentation/screens/create_new_group_screen.dart';

part 'leader_auto_router.gr.dart';

@AutoRouterConfig()
class LeaderAppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LeaderMainShellRoute.page, initial: true),
        AutoRoute(page: LeaderDashboardRoute.page),
        AutoRoute(page: LeaveRequestsRoute.page),
        AutoRoute(page: StudentResultsRoute.page),
        AutoRoute(page: HostelChatGroupsRoute.page),
        AutoRoute(page: AttendanceMainRoute.page),
        AutoRoute(page: GroupChatRoute.page),
        AutoRoute(page: CreateNewGroupRoute.page),
      ];
}
