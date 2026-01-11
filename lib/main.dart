import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/providers/auth_provider.dart';
import 'package:hsh_app/providers/theme_provider.dart';

import 'core/constants/app_text.dart';
import 'models/user_model.dart';
import 'modules/auth/screens/login_screen.dart';
import 'modules/complain/screens/complain_main_shell.dart';
import 'modules/laundry/screens/laundry_main_shell.dart';
import 'modules/student/student_main_shell.dart';
import 'router/app_router.dart';

/// 👇 Splash state provider
final splashFinishedProvider = StateProvider<bool>((ref) => false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'HSH App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      // Provide the router configuration
      routerConfig: goRouter,
    );
  }
}


