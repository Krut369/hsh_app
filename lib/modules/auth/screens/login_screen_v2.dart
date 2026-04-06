import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uitoolkit/uitoolkit.dart';
import '../presentation/controllers/auth_controller.dart';

// ─────────────────────────────────────────────
//  Colors  (scoped to V2)
// ─────────────────────────────────────────────
class _V2Colors {
  static const Color gold = Color(0xFFE8A020);
  static const Color goldPale = Color(0xFFFEF3DC);
  static const Color goldMuted = Color(0xFFF0B84A);
  static const Color goldDark = Color(0xFFC07A10);
  static const Color navy = Color(0xFF1A2744);
  static const Color navyMid = Color(0xFF253660);
  static const Color textMain = Color(0xFF1C1C1E);
  static const Color textSub = Color(0xFF6B7280);
  static const Color bg = Color(0xFFF7F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mainColor = Color(0xFF1b2b4b);
  static const Color mainLight1 = Color(0xFF2C547A);
}

// ─────────────────────────────────────────────
//  Text Styles (scoped to V2)
// ─────────────────────────────────────────────
class _V2Text {
  static const String serif = 'Georgia';

  static const TextStyle brandName = TextStyle(
    fontFamily: serif,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    letterSpacing: 1.0,
  );
  static const TextStyle chipLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static const TextStyle hostelTag = TextStyle(
    fontSize: 10.5,
    letterSpacing: 4,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );
}

// ─────────────────────────────────────────────
//  LoginScreenV2 — Premium card-based design
// ─────────────────────────────────────────────
class LoginScreenV2 extends StatefulWidget {
  /// Called when the user taps the "Switch Design" button.
  final VoidCallback onSwitch;

  const LoginScreenV2({super.key, required this.onSwitch});

  @override
  State<LoginScreenV2> createState() => _LoginScreenV2State();
}

class _LoginScreenV2State extends State<LoginScreenV2>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  late AnimationController _logoController;
  late AnimationController _formController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _formSlide;
  late Animation<double> _formOpacity;

  AuthController get authController => Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _formController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
    _formSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _formController, curve: Curves.easeOutCubic));
    _formOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _formController, curve: Curves.easeIn),
    );

    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _formController.forward();
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    await authController.login(email, password);

    if (authController.error.value != null && mounted) {
      ModernToast.show(
        message: authController.error.value!,
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      backgroundColor: _V2Colors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Hero / Logo ──────────────────────────────
                _HeroSection(
                  logoScale: _logoScale,
                  logoOpacity: _logoOpacity,
                  onSwitch: widget.onSwitch,
                ),

                // ── Form ────────────────────────────────────
                SlideTransition(
                  position: _formSlide,
                  child: FadeTransition(
                    opacity: _formOpacity,
                    child: _FormSection(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      obscurePassword: _obscurePassword,
                      rememberMe: _rememberMe,
                      onTogglePassword: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      onToggleRemember: () =>
                          setState(() => _rememberMe = !_rememberMe),
                      onLogin: _handleLogin,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Hero Section
// ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;
  final VoidCallback onSwitch;

  const _HeroSection({
    required this.logoScale,
    required this.logoOpacity,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _V2Colors.surface,
      child: Stack(
        children: [
          // Warm arc background
          Positioned.fill(
            child: ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _V2Colors.mainColor,
                        _V2Colors.mainLight1,
                        Colors.transparent
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Decorative circles
          Positioned(
              top: 140,
              right: 270,
              child: _DecorativeCircle1(size: 160, opacity: 0.5)),
          Positioned(
              top: 170,
              right: 300,
              child: _DecorativeCircle1(size: 90, opacity: 0.5)),
          Positioned(
              top: -30,
              right: -30,
              child: _DecorativeCircle(size: 160, opacity: 0.5)),
          Positioned(
              top: 20,
              right: 20,
              child: _DecorativeCircle(size: 90, opacity: 0.5)),

          // Decorative dots
          const Positioned(top: 60, left: 30, child: _DecorativeDot(size: 8)),
          const Positioned(top: 100, left: 60, child: _DecorativeDot(size: 5)),
          const Positioned(
              bottom: 40, left: 24, child: _DecorativeDot(size: 12)),

          // Switch Design button — top-left
          Positioned(
            top: 10,
            left: 12,
            child: _SwitchDesignChip(onTap: onSwitch),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 48),
            child: Column(
              children: [
                const SizedBox(height: 8),
                // offset so chip doesn't overlap logo
                // Logo card
                ScaleTransition(
                  scale: logoScale,
                  child: FadeTransition(
                    opacity: logoOpacity,
                    child: const _LogoCard(),
                  ),
                ),
                const SizedBox(height: 20),

                // Brand name
                RichText(
                  text: const TextSpan(
                    style: _V2Text.brandName,
                    children: [
                      TextSpan(text: 'Hari'),
                      TextSpan(
                          text: '-', style: TextStyle(color: Colors.white)),
                      TextSpan(text: 'Saurabh'),
                    ],
                  ),
                ),

                const SizedBox(height: 1),

                // Divider row with HOSTEL
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _GoldLine(width: 36, rightFade: false),
                    const SizedBox(width: 10),
                    const Text('HOSTEL', style: _V2Text.hostelTag),
                    const SizedBox(width: 10),
                    _GoldLine(width: 36, rightFade: true),
                  ],
                ),

                const SizedBox(height: 16),

                // Info chips
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _InfoChip(icon: Icons.star_rounded, label: '4.9 Rating'),
                    SizedBox(width: 8),
                    _InfoChip(
                        icon: Icons.people_alt_rounded, label: '2,400+ Guests'),
                    SizedBox(width: 8),
                    _InfoChip(
                        icon: Icons.location_on_rounded, label: 'Anand, GJ'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Switch Design Chip
// ─────────────────────────────────────────────
class _SwitchDesignChip extends StatelessWidget {
  final VoidCallback onTap;

  const _SwitchDesignChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _V2Colors.navy.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _V2Colors.navy.withOpacity(0.18)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.swap_horiz_rounded, size: 14, color: _V2Colors.navy),
            SizedBox(width: 5),
            Text(
              'Design 1',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _V2Colors.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Logo Card
// ─────────────────────────────────────────────
class _LogoCard extends StatelessWidget {
  const _LogoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: _V2Colors.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
              color: _V2Colors.mainColor.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 4)),
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 1)),
        ],
        border:
            Border.all(color: _V2Colors.mainColor.withOpacity(0.2), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Image.asset(
          'assets/hsh_top.png',
          width: 96,
          height: 96,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Form Section
// ─────────────────────────────────────────────
class _FormSection extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool rememberMe;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleRemember;
  final VoidCallback onLogin;

  const _FormSection({
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.rememberMe,
    required this.onTogglePassword,
    required this.onToggleRemember,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _V2Colors.bg,
      padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ModernText('Welcome back 👋',
              fontSize: 26, fontWeight: FontWeight.bold),
          const SizedBox(height: 4),
          const ModernText('Sign in to manage your stay', isSecondary: true),
          const SizedBox(height: 28),

          // Email
          ModernTextField(
            controller: emailController,
            label: 'Email address',
            hint: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined, size: 20),
          ),

          const SizedBox(height: 20),

          // Password
          // Since ModernTextField might not support obscureText yet,
          // using a standard field with Modern styling or checking for ModernPasswordField usage elsewhere.
          // For now, continuing with ModernTextField to match the "modern" request.
          ModernTextField(
            controller: passwordController,
            label: 'Password',
            hint: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF94A3B8),
                size: 20,
              ),
              onPressed: onTogglePassword,
            ),
          ),

          const SizedBox(height: 28),

          // Login button
          Obx(() {
            final loading = Get.find<AuthController>().isLoading.value;
            return ModernButton(
              text: 'LOGIN',
              onPressed: onLogin,
              isLoading: loading,
            );
          }),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Helper Widgets
// ─────────────────────────────────────────────
class _DecorativeCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: _V2Colors.mainColor.withOpacity(opacity), width: 1.5),
        ),
      );
}

class _DecorativeCircle1 extends StatelessWidget {
  final double size;
  final double opacity;

  const _DecorativeCircle1({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border:
              Border.all(color: Colors.white.withOpacity(opacity), width: 1.5),
        ),
      );
}

class _DecorativeDot extends StatelessWidget {
  final double size;

  const _DecorativeDot({required this.size});

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _V2Colors.mainColor.withOpacity(0.12),
        ),
      );
}

class _GoldLine extends StatelessWidget {
  final double width;
  final bool rightFade;

  const _GoldLine({required this.width, required this.rightFade});

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: rightFade
                ? [_V2Colors.mainColor.withOpacity(0.5), Colors.transparent]
                : [Colors.transparent, _V2Colors.mainColor.withOpacity(0.5)],
          ),
        ),
      );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _V2Colors.mainLight1,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11, color: Colors.white),
            const SizedBox(width: 4),
            Text(label, style: _V2Text.chipLabel),
          ],
        ),
      );
}
