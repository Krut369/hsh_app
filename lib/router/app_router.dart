import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/providers/auth_provider.dart';
import 'package:hsh_app/models/user_model.dart';
import 'package:hsh_app/models/laundry_order_model.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/splash_screen.dart';

import 'package:hsh_app/modules/auth/screens/login_screen.dart';
import 'package:hsh_app/modules/complain/complain_main_shell.dart';
import 'package:hsh_app/modules/student/student_main_shell.dart';

import 'package:hsh_app/modules/complain/features/management/complain_admin_screen.dart';
import 'package:hsh_app/modules/complain/features/feedback/complain_feedback_screen.dart';
import 'package:hsh_app/modules/complain/features/management/complaint_detail_view_screen.dart';
import 'package:hsh_app/modules/laundry/laundry_main_shell.dart';
import 'package:hsh_app/modules/laundry/features/chat/laundry_chat_details_screen.dart';
import 'package:hsh_app/modules/laundry/features/orders/laundry_order_detail_screen.dart';
import 'package:hsh_app/modules/leader/leader_main_shell.dart';
import 'package:hsh_app/modules/leader/features/attendance/attendance_main_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/group_chat_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/create_new_group_screen.dart';
import 'package:hsh_app/modules/leader/features/chat/finalize_group_screen.dart';
import 'package:hsh_app/models/chat_group_model.dart';

// Feature screens
import 'package:hsh_app/modules/student/features/attendance/attendance_screen.dart';
import 'package:hsh_app/modules/student/features/chat/chat_screen.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_screen.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_screen.dart';
import 'package:hsh_app/modules/student/features/notes/notes_screen.dart';
import 'package:hsh_app/modules/student/features/payment/payment_screen.dart';
import 'package:hsh_app/modules/student/features/services/all_services_screen.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_registration_screen.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/profile/profile_screen.dart';
import 'package:hsh_app/modules/student/features/laundry/laundry_screen.dart';

import 'package:hsh_app/modules/student/features/complaint/add_complaint_screen.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_form.dart';
import 'package:hsh_app/modules/student/features/chat/chat_details_screen.dart';

// ---------------------------------------------------------------------------
// RouterNotifier
// ---------------------------------------------------------------------------
// Extends ChangeNotifier so GoRouter can use it as refreshListenable.
// It watches authProvider and calls notifyListeners() when it changes,
// which tells GoRouter to re-evaluate its redirect — WITHOUT recreating the
// GoRouter instance or destroying any widget state.
// ---------------------------------------------------------------------------
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    // Listen to authProvider changes and notify GoRouter to re-check redirects.
    _ref.listen<AsyncValue<AuthState>>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }

  /// Called by GoRouter's redirect callback — reads (not watches) auth state.
  String? redirect(BuildContext context, GoRouterState state) {
    final authState = _ref.read(authProvider);
    final isLoggingIn = state.uri.toString() == '/login';
    final isSplash = state.uri.toString() == '/';

    // While the auth state is loading (initial check), stay on splash.
    if (authState.isLoading) return null;

    final authData = authState.value;
    final isAuthenticated = authData?.isAuthenticated ?? false;
    final hasError = authData?.error != null;

    // Unauthenticated user
    if (!isAuthenticated) {
      // If a login error occurred while on the splash screen, push to login
      // so the LoginScreen can display the error banner.
      if (hasError && isSplash) return '/login';
      if (isLoggingIn || isSplash) return null; // Allow splash / login
      return '/login';
    }

    // Authenticated user — redirect away from splash / login.
    if (isLoggingIn || isSplash) {
      final role = authData?.user?.role;
      switch (role) {
        case UserRole.laundry:
          return '/laundry';
        case UserRole.complain:
          return '/complain';
        case UserRole.leader:
          return '/leader';
        case UserRole.student:
          return '/student/profile';
        default:
          return '/student/profile';
      }
    }

    // If accessing /student directly, redirect to profile.
    if (state.uri.toString() == '/student') return '/student/profile';

    return null;
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

/// Provides the RouterNotifier singleton — created once, never recreated.
final routerNotifierProvider = Provider<RouterNotifier>(
  (ref) => RouterNotifier(ref),
);

/// Provides the GoRouter singleton — created ONCE for the lifetime of the app.
///
/// KEY POINT: uses ref.read (not ref.watch) so the GoRouter is never recreated
/// when authProvider changes. Auth changes flow through RouterNotifier →
/// notifyListeners() → GoRouter re-evaluates redirect only.
final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = ref.read(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier, // GoRouter re-checks redirect on auth change
    redirect: notifier.redirect, // Delegate to RouterNotifier
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Student Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return StudentMainShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 1: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/profile',
                builder: (context, state) => ProfileScreen(),
              ),
            ],
          ),

          // Branch 2: Complaint
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/complaint',
                builder: (context, state) => const ComplaintScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const AddComplaintScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Branch 3: Laundry
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/laundry',
                builder: (context, state) => const LaundryScreen(),
              ),
            ],
          ),

          // Branch 4: Attendance
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/student/attendance',
                builder: (context, state) => const AttendanceScreen(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Student Routes (hides bottom nav)
      GoRoute(
        path: '/student/chat',
        builder: (context, state) => const ChatScreen(),
        routes: [
          GoRoute(
            path: 'details',
            builder: (context, state) => const ChatDetailsScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/student/notes',
        builder: (context, state) => const NotesScreen(),
      ),
      GoRoute(
        path: '/student/holiday',
        builder: (context, state) => const HolidayScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => const HolidayForm(),
          ),
        ],
      ),
      GoRoute(
        path: '/student/payment',
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path:
            '/student/services-all', // Renamed to avoid conflict if needed, or just keep unique
        builder: (context, state) => const AllServicesScreen(),
      ),
      GoRoute(
        path: '/student/vehicle-registration',
        builder: (context, state) => const VehicleRegistrationScreen(),
      ),
      GoRoute(
        path: '/student/orders',
        builder: (context, state) {
          final order = state.extra as LaundryOrder;
          return OrderDetailsScreen(order: order);
        },
      ),

      // Other Roles
      GoRoute(
        path: '/laundry',
        builder: (context, state) => const LaundryMainShell(),
        routes: [
          GoRoute(
            path: 'chat/details',
            builder: (context, state) {
              final convId = state.extra as String?;
              return LaundryChatDetailsScreen(conversationId: convId);
            },
          ),
          GoRoute(
            path: 'order-detail',
            builder: (context, state) {
              final order = state.extra as LaundryOrder;
              return LaundryOrderDetailScreen(order: order);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/complain',
        builder: (context, state) => const ComplainMainShell(),
        routes: [
          GoRoute(
            path: 'feedback',
            builder: (context, state) => const ComplainFeedbackScreen(),
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

      // Leader Routes
      GoRoute(
        path: '/leader',
        builder: (context, state) => const LeaderMainShell(),
        routes: [
          GoRoute(
            path: 'attendance',
            builder: (context, state) => const AttendanceMainScreen(),
          ),
          GoRoute(
            path: 'chat/messages',
            builder: (context, state) {
              final group = state.extra as ChatGroup;
              return GroupChatScreen(group: group);
            },
          ),
          GoRoute(
            path: 'chat/create',
            builder: (context, state) => const CreateNewGroupScreen(),
          ),
          GoRoute(
            path: 'chat/finalize',
            builder: (context, state) => const FinalizeGroupScreen(),
          ),
        ],
      ),
    ],
  );
});
