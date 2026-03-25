import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';
import '../presentation/controllers/auth_controller.dart';

/// Brand colors for the Hari-Saurabh Hostel login screen.
class _LoginScreenColors {
  static const Color darkBlue = Color(0xFF1A365D);
  static const Color paleBlue = Color(0xFFEBF8FF);

  /// Large top header curve (design ref. #EBF2F8).
  static const Color headerCurve = Color(0xFFEBF2F8);
  static const Color hint = Color(0xFF6B8299);
}

/// Clips the top header to a wide arc (bottom edge curves downward in the center).
class _LoginTopCurveClipper extends CustomClipper<Path> {
  static const double _arcEdgeY = 0.78;
  static const double _arcControlY = 1.12;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * _arcEdgeY);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * _arcControlY,
      0,
      size.height * _arcEdgeY,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _LoginTopCurveClipper oldClipper) => false;
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

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _emailFieldKey = GlobalKey();
  final GlobalKey _passwordFieldKey = GlobalKey();

  AuthController get authController => Get.find<AuthController>();

  void _scrollToFocusedField(GlobalKey key) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        alignment: 0.05,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearLocalError);
    _passwordController.addListener(_clearLocalError);

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _scrollToFocusedField(_emailFieldKey);
      }
    });
    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _scrollToFocusedField(_passwordFieldKey);
      }
    });
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
    _scrollController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
    required String label,
    required Widget prefixIcon,
    Widget? suffixIcon,
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: _LoginScreenColors.hint, fontSize: 15),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      labelText: label,
      labelStyle: const TextStyle(
        color: _LoginScreenColors.darkBlue,
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        backgroundColor: _LoginScreenColors.paleBlue,
      ),
      floatingLabelStyle: const TextStyle(
        color: _LoginScreenColors.darkBlue,
        fontSize: 12.5,
        fontWeight: FontWeight.w600,
        backgroundColor: _LoginScreenColors.paleBlue,
      ),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            BorderSide(color: _LoginScreenColors.darkBlue.withOpacity(0.25)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            BorderSide(color: _LoginScreenColors.darkBlue.withOpacity(0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide:
            const BorderSide(color: _LoginScreenColors.darkBlue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxFieldWidth =
        MediaQuery.of(context).size.width < 400 ? double.infinity : 380.0;
    final screenW = MediaQuery.sizeOf(context).width;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final headerHeight = screenW * 1.05;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              width: screenW,
              height: headerHeight,
              child: ClipPath(
                clipper: _LoginTopCurveClipper(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: _LoginScreenColors.headerCurve),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/hsh_top.png',
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.fromLTRB(
                  28,
                  24,
                  28,
                  24 + viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxFieldWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/hsh_down.png',
                            height: 76,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: screenW * 0.06 + 8),
                          Text(
                            'Login',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              color: _LoginScreenColors.darkBlue,
                            ),
                          ),
                          const SizedBox(height: 28),
                        ],
                      ),
                      Container(
                        key: _emailFieldKey,
                        child: TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: const TextStyle(
                            color: _LoginScreenColors.darkBlue,
                            fontSize: 15,
                          ),
                          focusNode: _emailFocusNode,
                          decoration: _pillDecoration(
                            label: 'Email',
                            hintText: 'email@gmail.com',
                            prefixIcon: const Icon(
                              Icons.mail_outline_rounded,
                              color: _LoginScreenColors.darkBlue,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        key: _passwordFieldKey,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _onLogin(),
                          style: const TextStyle(
                            color: _LoginScreenColors.darkBlue,
                            fontSize: 15,
                          ),
                          focusNode: _passwordFocusNode,
                          decoration: _pillDecoration(
                            label: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: _LoginScreenColors.darkBlue,
                              size: 22,
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
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Obx(() {
                        final loading = authController.isLoading.value;
                        return SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: loading ? null : _onLogin,
                            style: FilledButton.styleFrom(
                              backgroundColor: _LoginScreenColors.paleBlue,
                              foregroundColor: _LoginScreenColors.darkBlue,
                              disabledBackgroundColor:
                                  _LoginScreenColors.paleBlue.withOpacity(0.85),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: loading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: _LoginScreenColors.darkBlue,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
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
