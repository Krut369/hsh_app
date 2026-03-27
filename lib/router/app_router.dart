import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';

// This file is now legacy and mostly serves to hold the RouterNotifier 
// if any parts of the app still rely on it during transition.
// However, most logic has moved to AuthMiddleware in app_pages.dart.

class RouterNotifier extends ChangeNotifier {
  RouterNotifier() {
    final authController = Get.find<AuthController>();
    authController.isAuthenticated.listen((_) => notifyListeners());
    authController.user.listen((_) => notifyListeners());
    authController.isLoading.listen((_) => notifyListeners());
    authController.error.listen((_) => notifyListeners());
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
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return StudentMainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student/profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
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
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/student/laundry',
              builder: (context, state) => const LaundryScreen(),
            ),
          ],
        ),
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
