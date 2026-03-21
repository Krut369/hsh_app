import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';
import '../presentation/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _cardAnim;
  late Animation<double> _logoAnim;

  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _cardAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _logoAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _animController.forward();

    _emailController.addListener(_clearLocalError);
    _passwordController.addListener(_clearLocalError);
  }

  void _clearLocalError() {
    if (authController.error.value != null) {
      authController.error.value = null;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ModernToast.show(
        message: 'Please enter both email and password.',
        type: ToastType.error,
      );
      return;
    }

    await authController.login(email, password);

    if (authController.error.value != null) {
      ModernToast.show(
        message: _friendlyError(authController.error.value!),
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return ModernScaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _cardAnim,
            child: ScaleTransition(
              scale: _cardAnim,
              child: Container(
                width: size.width < 400 ? size.width * 0.92 : 380,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _logoAnim,
                      child: ScaleTransition(
                        scale: _logoAnim,
                        child: CircleAvatar(
                          radius: 38,
                          backgroundColor: const Color(0xFFe0eafc),
                          child: Icon(Icons.lock_outline,
                              size: 44, color: theme.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ModernTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      prefixIcon: const Icon(Icons.email_outlined),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    ModernTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 28),
                    Obx(() => ModernButton(
                          text: 'Log In',
                          onPressed: _onLogin,
                          isLoading: authController.isLoading.value,
                        )),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _friendlyError(String error) {
    if (error.isEmpty) return 'An error occurred. Please try again.';
    final lower = error.toLowerCase();
    if (lower.contains('invalid') ||
        lower.contains('incorrect') ||
        lower.contains('wrong') ||
        lower.contains('credentials') ||
        lower.contains('401')) {
      return 'Incorrect email or password.';
    }
    if (lower.contains('network') ||
        lower.contains('socket') ||
        lower.contains('connection')) {
      return 'Network error. Please check your connection.';
    }
    return error;
  }
}
