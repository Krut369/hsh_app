import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/providers/auth_provider.dart';
import 'package:hsh_app/models/user_model.dart';
import 'package:hsh_app/splash_screen.dart';

import 'package:hsh_app/modules/auth/screens/login_screen.dart';
import 'package:hsh_app/modules/student/student_main_shell.dart';
import 'package:hsh_app/modules/complain/screens/complain_main_shell.dart';
import 'package:hsh_app/modules/laundry/screens/laundry_main_shell.dart';

// Feature screens
import 'package:hsh_app/modules/student/features/attendance/attendance_screen.dart';
import 'package:hsh_app/modules/student/features/chat/chat_screen.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_screen.dart';
import 'package:hsh_app/modules/student/features/holiday/holiday_payment_screen.dart';
import 'package:hsh_app/modules/student/features/notes/notes_screen.dart';
import 'package:hsh_app/modules/student/features/payment/payment_screen.dart';
import 'package:hsh_app/modules/student/features/services/all_services_screen.dart';
import 'package:hsh_app/modules/student/features/vehicle/vehicle_registration_screen.dart';
import 'package:hsh_app/modules/student/features/orders/order_details_screen.dart';


final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: ValueNotifier(authState), // Re-evaluate redirection on auth change
    redirect: (context, state) {
      final isLoggingIn = state.uri.toString() == '/login';
      final isSplash = state.uri.toString() == '/';
      
      // If loading or error, stay on splash or login (handled by UI state usually, 
      // but here we check data)
      if (authState.isLoading) return null; // Stay where we are (splash likely)
      
      final isAuthenticated = authState.value?.isAuthenticated ?? false;

      // Unauthenticated user
      if (!isAuthenticated) {
        if (isLoggingIn || isSplash) return null; // Allow splash/login
        return '/login';
      }

      // Authenticated user
      if (isLoggingIn || isSplash) {
        // Redirect based on role
        final role = authState.value?.user?.role;
        switch (role) {
          case UserRole.laundry:
            return '/laundry';
          case UserRole.complain:
            return '/complain';
          case UserRole.student:
          default:
            return '/student';
        }
      }

      return null;
    },
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
      GoRoute(
        path: '/student',
        builder: (context, state) => const StudentMainShell(),
        routes: [
           GoRoute(
             path: 'attendance',
             builder: (context, state) => const AttendanceScreen(),
           ),
           GoRoute(
             path: 'chat',
             builder: (context, state) => const ChatScreen(),
           ),
           GoRoute(
             path: 'complaint',
             builder: (context, state) => const ComplaintScreen(),
           ),
           GoRoute(
             path: 'holiday',
             builder: (context, state) => const HolidayPaymentScreen(),
           ),
           GoRoute(
             path: 'notes',
             builder: (context, state) => const NotesScreen(),
           ),
           GoRoute(
             path: 'payment',
             builder: (context, state) => const PaymentScreen(),
           ),
           GoRoute(
             path: 'services',
             builder: (context, state) => const AllServicesScreen(),
           ),
           GoRoute(
             path: 'vehicle-registration',
             builder: (context, state) => const VehicleRegistrationScreen(),
           ),
             GoRoute(
             path: 'orders',
             builder: (context, state) => const OrderDetailsScreen(),
           ),
        ],
      ),

      // Other Roles
      GoRoute(
        path: '/laundry',
        builder: (context, state) => const LaundryMainShell(),
      ),
      GoRoute(
        path: '/complain',
        builder: (context, state) => const ComplainMainShell(),
      ),
    ],
  );
});
