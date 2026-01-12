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
import 'package:hsh_app/modules/laundry/screens/laundry_main_shell.dart';

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
            // Redirect to the first tab (Profile)
            return '/student/profile';
          default:
            return '/student/profile';
        }
      }

      // If accessing /student directly, redirect to profile
      if (state.uri.toString() == '/student') {
        return '/student/profile';
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

           // Branch 5: Leave / Holiday (Hidden/Extra)
          StatefulShellBranch(
            routes: [
              GoRoute(
                  path: '/student/leave',
                  builder: (context, state) => const HolidayScreen(),
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
        path: '/student/services-all', // Renamed to avoid conflict if needed, or just keep unique
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
    ],
  );
});
