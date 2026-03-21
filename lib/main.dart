import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/auth/presentation/bindings/auth_binding.dart';
import 'package:hsh_app/providers/theme_provider.dart' show themeProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences first
  final sharedPrefs = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPrefs);

  // Initialize GetX dependencies
  AuthBinding().dependencies();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    final goRouter = ref.watch(goRouterProvider);

    return GetMaterialApp.router(
      title: 'HSH App',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      routeInformationParser: goRouter.routeInformationParser,
      routerDelegate: goRouter.routerDelegate,
      routeInformationProvider: goRouter.routeInformationProvider,
    );
  }
}
