import "package:hsh_app/core/enums/user_role.dart";
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/splash_screen.dart';
import 'package:hsh_app/modules/auth/screens/login_screen.dart';
import 'package:hsh_app/modules/complain/presentation/complain_routes.dart';
import 'package:hsh_app/modules/laundry/presentation/laundry_routes.dart';
import 'package:hsh_app/modules/leader/presentation/leader_routes.dart';

// Feature screens
import 'package:hsh_app/modules/student/features/chat/chat_screen.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_screen.dart';
import 'package:hsh_app/modules/student/features/notes/notes_screen.dart';
import 'package:hsh_app/modules/student/features/payment/payment_screen.dart';
import 'package:hsh_app/modules/student/features/services/all_services_screen.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_registration_screen.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_form.dart';
import 'package:hsh_app/modules/student/features/chat/chat_details_screen.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

// ---------------------------------------------------------------------------
// RouterNotifier
// ---------------------------------------------------------------------------
class RouterNotifier extends ChangeNotifier {
  RouterNotifier() {
    final authController = Get.find<AuthController>();
    authController.isAuthenticated.listen((_) => notifyListeners());
    authController.user.listen((_) => notifyListeners());
    authController.isLoading.listen((_) => notifyListeners());
    authController.error.listen((_) => notifyListeners());
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final authController = Get.find<AuthController>();
    final isLoggingIn = state.uri.toString() == '/login';
    final isSplash = state.uri.toString() == '/';

    if (authController.isLoading.value) return null;

    final isAuthenticated = authController.isAuthenticated.value;
    final hasError = authController.error.value != null;

    if (!isAuthenticated) {
      if (hasError && isSplash) return '/login';
      if (isLoggingIn || isSplash) return null;
      return '/login';
    }

    final user = authController.user.value;
    final role = user?.role;
    final currentPath = state.uri.toString();

    if (isLoggingIn) {
      return _getDashboardForRole(role);
    }

    if (currentPath != '/') {
      if (role == UserRole.laundry && !currentPath.startsWith('/laundry')) {
        return '/laundry';
      }
      if (role == UserRole.complain && !currentPath.startsWith('/complain')) {
        return '/complain';
      }
      if (role == UserRole.leader && !currentPath.startsWith('/leader')) {
        return '/leader';
      }
      if (role == UserRole.student && !currentPath.startsWith('/student')) {
        return '/student/profile';
      }
    }

    if (currentPath == '/student') return '/student/profile';

    return null;
  }

  String _getDashboardForRole(UserRole? role) {
    switch (role) {
      case UserRole.laundry:
        return '/laundry';
      case UserRole.complain:
        return '/complain';
      case UserRole.leader:
        return '/leader';
      case UserRole.student:
      default:
        return '/student/profile';
    }
  }
}

// ---------------------------------------------------------------------------
// Global GoRouter instance
// ---------------------------------------------------------------------------
final routerNotifier = RouterNotifier();

final goRouter = GoRouter(
  navigatorKey: Get.key,
  initialLocation: '/',
  refreshListenable: routerNotifier,
  redirect: routerNotifier.redirect,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // Student Shell
    // StatefulShellRoute.indexedStack(
    //   builder: (context, state, navigationShell) {
    //     return StudentMainShell(navigationShell: navigationShell);
    //   },
    //   branches: [
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: '/student/profile',
    //           builder: (context, state) => ProfileScreen(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: '/student/complaint',
    //           builder: (context, state) => const ComplaintScreen(),
    //           routes: [
    //             GoRoute(
    //               path: 'add',
    //               builder: (context, state) => const AddComplaintScreen(),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: '/student/laundry',
    //           builder: (context, state) => const LaundryScreen(),
    //         ),
    //       ],
    //     ),
    //     StatefulShellBranch(
    //       routes: [
    //         GoRoute(
    //           path: '/student/attendance',
    //           builder: (context, state) => const AttendanceScreen(),
    //         ),
    //       ],
    //     ),
    //   ],
    // ),

    // Standalone Student Routes
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
        GoRoute(path: 'add', builder: (context, state) => const HolidayForm()),
      ],
    ),
    GoRoute(
      path: '/student/payment',
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: '/student/services-all',
      builder: (context, state) => const AllServicesScreen(),
    ),
    GoRoute(
      path: '/student/vehicle-registration',
      builder: (context, state) => const VehicleRegistrationScreen(),
    ),
    GoRoute(
      path: '/student/orders',
      builder: (context, state) {
        final order = state.extra as LaundryOrderEntity;
        return OrderDetailsScreen(order: order);
      },
    ),

    // Other Roles
    ...LaundryRoutes.routes,
    ...ComplainRoutes.routes,
    ...LeaderRoutes.routes,
  ],
);
