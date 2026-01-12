import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/auth_provider.dart';

final obscurePasswordProvider = StateProvider<bool>((ref) => true);
final rememberMeProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _lastError;
  late AnimationController _animController;
  late Animation<double> _cardAnim;
  late Animation<double> _logoAnim;

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    final notifier = ref.read(authProvider.notifier);
    await notifier.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;
    final error = authState.valueOrNull?.error;
    final obscurePassword = ref.watch(obscurePasswordProvider);

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    // Show error only once
    if (error != null && error != _lastError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      });
      _lastError = error;
    }
    if (error == null) {
      _lastError = null;
    }

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4F8FFF),
                  Color(0xFF6DC8F3),
                  Color(0xFFe0eafc),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Centered content
          Center(
            child: SingleChildScrollView(
              child: FadeTransition(
                opacity: _cardAnim,
                child: ScaleTransition(
                  scale: _cardAnim,
                  child: Container(
                    width: size.width < 400 ? size.width * 0.92 : 380,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 32),
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
                        // Logo/avatar
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
                        const SizedBox(height: 6),

                        const SizedBox(height: 28),
                        //
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Password
                        TextField(
                          controller: _passwordController,
                          obscureText: obscurePassword,
                          autofillHints: const [AutofillHints.password],
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                ref
                                    .read(obscurePasswordProvider.notifier)
                                    .state = !obscurePassword;
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 2,
                            ),
                            onPressed: isLoading ? null : _onLogin,
                            child: isLoading
                                ? const SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        // Divider
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
