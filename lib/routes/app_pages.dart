import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hsh_app/modules/auth/screens/login_screen.dart';
import 'package:hsh_app/modules/student/presentation/routes/student_routes.dart';
import 'package:hsh_app/modules/laundry/presentation/laundry_routes.dart';
import 'package:hsh_app/modules/complain/presentation/complain_routes.dart';
import 'package:hsh_app/modules/leader/presentation/leader_routes.dart';
import 'package:hsh_app/modules/auth/screens/splash_screen.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:hsh_app/core/enums/user_role.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: '/',
      page: () => const SplashScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: '/login',
      page: () => const LoginScreen(),
      middlewares: [AuthMiddleware()],
    ),
    
    // Student Module (Direct GetX Routes)
    ...StudentRoutes.pages,

    // Legacy Module Wrappers (Keeping GoRouter for now as requested)
    GetPage(
      name: '/laundry_module',
      page: () => Router.withConfig(
        config: GoRouter(routes: LaundryRoutes.routes, initialLocation: '/laundry'),
      ),
    ),
    GetPage(
      name: '/complain_module',
      page: () => Router.withConfig(
        config: GoRouter(routes: ComplainRoutes.routes, initialLocation: '/complain'),
      ),
    ),
    GetPage(
      name: '/leader_module',
      page: () => Router.withConfig(
        config: GoRouter(routes: LeaderRoutes.routes, initialLocation: '/leader'),
      ),
    ),
  ];
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    
    if (authController.isLoading.value) return null;
    
    if (!authController.isAuthenticated.value) {
      if (route == '/login') return null;
      return const RouteSettings(name: '/login');
    }

    final user = authController.user.value;
    if (user == null) {
      debugPrint('Middleware: User is null, redirecting to /login');
      return const RouteSettings(name: '/login');
    }

    debugPrint('Middleware: Authenticated as ${user.role}, redirecting from $route');

    if (route == '/' || route == '/login') {
      switch (user.role) {
        case UserRole.student:
          return const RouteSettings(name: StudentRoutes.shell);
        case UserRole.laundry:
          return const RouteSettings(name: '/laundry_module');
        case UserRole.complain:
          return const RouteSettings(name: '/complain_module');
        case UserRole.leader:
          return const RouteSettings(name: '/leader_module');
      }
    }

    return null;
  }
}
