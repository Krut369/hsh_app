import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/user_model.dart';
import '../../../providers/auth_provider.dart';
import '../../complain/screens/complain_main_shell.dart';
import '../../laundry/screens/laundry_main_shell.dart';
import '../../student/screens/student_main_shell.dart';

final isLoadingProvider = StateProvider<bool>((ref) => false);
final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final rememberMeProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _onLogin() async {
    final notifier = ref.read(authProvider.notifier);
    ref.read(isLoadingProvider.notifier).state = true;
    await notifier.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    ref.read(isLoadingProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLoading = ref.watch(isLoadingProvider);
    final obscurePassword = ref.watch(obscurePasswordProvider);
    final rememberMe = ref.watch(rememberMeProvider);

    /// ✅ Handle authentication result & navigate
    ref.listen<AsyncValue<AuthState>>(authProvider, (previous, next) {
      if (!mounted) return;
      final state = next.value;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (state != null && state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        } else if (state != null && state.isAuthenticated) {
          final role = state.user!.role;
          Widget screen;

          if (role == UserRole.student) {
            screen = const StudentMainShell();
          } else if (role == UserRole.laundry) {
            screen = const LaundryMainShell();
          } else {
            screen = const ComplainMainShell();
          }

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Curved gradient header
              Stack(
                children: [
                  ClipPath(
                    clipper: _HeaderClipper(),
                    child: Container(
                      width: double.infinity,
                      height: size.height * 0.28,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(Icons.arrow_back, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: size.height * 0.18,
                    child: Column(
                      children: [
                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              /// Elevated Card-Like Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Email
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.primary),
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Password
                      TextField(
                        controller: _passwordController,
                        obscureText: obscurePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.primary),
                          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.primary,
                            ),
                            onPressed: () => ref.read(obscurePasswordProvider.notifier).state = !obscurePassword,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Remember Me & Forgot Password
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (v) => ref.read(rememberMeProvider.notifier).state = v ?? false,
                            activeColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          Text('Remember Me', style: TextStyle(color: AppColors.textPrimary)),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot Password ?',
                              style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                            elevation: 2,
                          ),
                          onPressed: isLoading ? null : _onLogin,
                          child: isLoading
                              ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          )
                              : const Text(
                            'Log In',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Sign up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.82);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.95,
      size.width * 0.5, size.height * 0.82,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.69,
      size.width, size.height * 0.82,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
