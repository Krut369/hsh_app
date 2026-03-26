import 'package:go_router/go_router.dart';
import 'package:hsh_app/modules/complain/presentation/screens/complain_main_shell.dart';
import 'package:hsh_app/modules/complain/presentation/screens/feedback/complain_feedback_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complain_admin_screen.dart';
import 'package:hsh_app/modules/complain/presentation/screens/management/complaint_detail_view_screen.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';

import '../../student/features/complaint/add_complaint_screen.dart';

class ComplainRoutes {
  static const String main = '/complain';
  static const String feedback = '/complain/feedback';
  static const String admin = '/complain/admin';
  static const String detail = '/complain/detail';
  static const String add = '/complain/add';

  static final List<RouteBase> routes = [
    GoRoute(
      path: main,
      builder: (context, state) => const ComplainMainShell(),
      routes: [
        GoRoute(
          path: 'feedback',
          builder: (context, state) => const ComplainFeedbackScreen(),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const AddComplaintScreen(),
        ),
        GoRoute(
          path: 'admin',
          builder: (context, state) => const ComplaintAdminScreen(),
        ),
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final complaint = state.extra as Complaint;
            return ComplaintDetailViewScreen(complaint: complaint);
          },
        ),
      ],
    ),
  ];
}
