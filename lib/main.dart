import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/providers/theme_provider.dart' show themeProvider;
import 'router/app_router.dart';

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
      routerConfig: goRouter,
    );
  }
}
