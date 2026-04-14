import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/complain/presentation/bindings/complain_binding.dart';
import 'package:hsh_app/modules/leader/presentation/bindings/leader_binding.dart';
import 'package:hsh_app/modules/auth/presentation/bindings/auth_binding.dart';
import 'package:hsh_app/modules/laundry/presentation/bindings/laundry_binding.dart';
import 'package:hsh_app/modules/student/features/profile/bindings/profile_binding.dart';
import 'package:hsh_app/modules/student/features/attendance/bindings/attendance_binding.dart';
import 'package:hsh_app/modules/student/features/scanner/bindings/mobile_scanner_binding.dart';
import 'package:hsh_app/controllers/chat_controller.dart';
import 'package:hsh_app/providers/bottom_nav_provider.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hsh_app/routes/app_pages.dart';
import 'package:hsh_app/modules/auth/screens/splash_screen.dart';
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first
  final sharedPrefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPrefs);

  // Initialize GetX dependencies
  AuthBinding().dependencies();
  LaundryBinding().dependencies();
  ComplainBinding().dependencies();
  LeaderBinding().dependencies();
  ProfileBinding().dependencies();
  AttendanceBinding().dependencies();
  MobileScannerBinding().dependencies();
  Get.put(ChatController());
  Get.put(BottomNavController());
  Get.put(UIController());

  runApp(
    ProviderScope(
      child: ModernApp(
        title: 'HSH App',
        debugShowCheckedModeBanner: false,
        getPages: AppPages.pages,
        home: const SplashScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          AppFlowyEditorLocalizations.delegate,
        ],
      ),
    ),
  );
}
