import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/providers/auth_provider.dart';
import 'package:hsh_app/providers/theme_provider.dart';

import 'models/user_model.dart';
import 'modules/auth/screens/login_screen.dart';
import 'modules/complain/screens/complain_main_shell.dart';
import 'modules/laundry/screens/laundry_main_shell.dart';
import 'modules/student/screens/student_main_shell.dart';

import 'core/constants/app_text.dart';
import 'splash_screen.dart';

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
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      title: AppText.appTitle,
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const _AppRoot(),
    );
  }
}

class _AppRoot extends ConsumerStatefulWidget {
  const _AppRoot({super.key});

  @override
  ConsumerState<_AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<_AppRoot> {
  ProviderSubscription<AsyncValue<AuthState>>? _authSubscription;

  @override
  void initState() {
    super.initState();

    // ✅ Splash Delay
    Future.delayed(const Duration(seconds: 2), () {
      ref.read(splashFinishedProvider.notifier).state = true;
    });

    // ✅ Safe listener for auth error
    _authSubscription = ref.listenManual<AsyncValue<AuthState>>(
      authProvider,
          (previous, next) {
        final error = next.valueOrNull?.error;
        if (error != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _authSubscription?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final splashFinished = ref.watch(splashFinishedProvider);
    final auth = ref.watch(authProvider);

    if (!splashFinished) return const SplashScreen();

    if (auth.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (auth.hasValue && auth.value!.isAuthenticated) {
      final role = auth.value!.user!.role;
      switch (role) {
        case UserRole.laundry:
          return const LaundryMainShell();
        case UserRole.complain:
          return const ComplainMainShell();
        case UserRole.student:
          return const StudentMainShell();
      }
    }

    return const LoginScreen();
  }
}
