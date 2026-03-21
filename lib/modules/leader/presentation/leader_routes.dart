import 'package:go_router/go_router.dart';
import 'package:hsh_app/modules/leader/leader_main_shell.dart';
import 'package:hsh_app/modules/leader/features/attendance/attendance_main_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/group_chat_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/create_new_group_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/finalize_group_screen.dart';
import 'package:hsh_app/models/chat_group_model.dart';

class LeaderRoutes {
  static const String main = '/leader';
  static const String attendance = 'attendance';
  static const String chatMessages = 'chat/messages';
  static const String chatCreate = 'chat/create';
  static const String chatFinalize = 'chat/finalize';

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
        GoRoute(
          path: chatFinalize,
          builder: (context, state) => const FinalizeGroupScreen(),
        ),
      ],
    ),
  ];
}
