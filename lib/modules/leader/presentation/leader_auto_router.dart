import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:hsh_app/models/chat_group_model.dart';
import 'package:hsh_app/modules/leader/leader_main_shell.dart';
import 'package:hsh_app/modules/leader/features/dashboard/leader_dashboard_screen.dart';
import 'package:hsh_app/modules/leader/features/leave_requests/leave_requests_screen.dart';
import 'package:hsh_app/modules/leader/features/student_results/student_results_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/hostel_chat_groups_screen.dart';
import 'package:hsh_app/modules/leader/features/attendance/attendance_main_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/group_chat_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/create_new_group_screen.dart';

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
