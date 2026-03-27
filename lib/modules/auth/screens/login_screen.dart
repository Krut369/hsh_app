import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';
import '../presentation/controllers/auth_controller.dart';

/// Brand colors
class _LoginScreenColors {
  static const Color darkBlue = Color(0xFF1A365D);
  static const Color hint = Color(0xFF6B8299);
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
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

  InputDecoration _pillDecoration({
    required String hintText,
    required Widget prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: _LoginScreenColors.hint,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      filled: true,
      // Semi-transparent so the background still shows through.
      fillColor: Colors.white.withOpacity(0.18),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide:
            BorderSide(color: _LoginScreenColors.darkBlue.withOpacity(0.22)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide:
            BorderSide(color: _LoginScreenColors.darkBlue.withOpacity(0.28)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(
          color: _LoginScreenColors.darkBlue,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxFieldWidth =
        MediaQuery.of(context).size.width < 400 ? double.infinity : 380.0;

    final screenH = MediaQuery.of(context).size.height;

    final topPadding =
        (screenH * 0.38).clamp(160.0, 300.0); // better positioning

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            /// 🔥 FIXED BACKGROUND
            Positioned.fill(
              child: Image.asset(
                'assets/login screen bg.jpeg',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                filterQuality: FilterQuality.high,
              ),
            ),

            /// light overlay (optional)
            Positioned.fill(
              child: Container(
                color: Colors.white.withOpacity(0.02),
              ),
            ),
            /// UI
            Padding(
              
              padding: EdgeInsets.fromLTRB(28, topPadding, 28, 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxFieldWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _LoginScreenColors.darkBlue,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      /// EMAIL
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autocorrect: false,
                          enableSuggestions: false,
                          cursorColor: _LoginScreenColors.darkBlue,
                          style: const TextStyle(
                            color: _LoginScreenColors.darkBlue,
                            fontSize: 16,
                          ),
                          decoration: _pillDecoration(
                            hintText: 'Email or Phone',
                            prefixIcon: const Icon(
                              Icons.mail_outline_rounded,
                              color: _LoginScreenColors.darkBlue,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PASSWORD
                      SizedBox(
                        width: double.infinity,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLogin(),
                          autocorrect: false,
                          enableSuggestions: false,
                          cursorColor: _LoginScreenColors.darkBlue,
                          style: const TextStyle(
                            color: _LoginScreenColors.darkBlue,
                            fontSize: 16,
                          ),
                          decoration: _pillDecoration(
                            hintText: 'Password',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: _LoginScreenColors.darkBlue,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: _LoginScreenColors.darkBlue,
                                size: 24,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 40,
                                minHeight: 40,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      /// LOGIN BUTTON
                      Obx(() {
                        final loading = authController.isLoading.value;

                        return SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _LoginScreenColors.darkBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              disabledBackgroundColor:
                                  _LoginScreenColors.darkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            onPressed: loading ? null : _onLogin,
                            child: loading
                                ? const SizedBox(
                                    height: 22,
                                    width: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _friendlyError(String error) {
    final lower = error.toLowerCase();

    if (lower.contains('invalid') ||
        lower.contains('incorrect') ||
        lower.contains('401')) {
      return 'Incorrect email or password.';
    }

    if (lower.contains('network')) {
      return 'Check your internet connection.';
    }

    return error;
  }
}
