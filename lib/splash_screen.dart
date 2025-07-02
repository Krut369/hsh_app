// Requires flutter_riverpod in pubspec.yaml
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'modules/auth/screens/login_screen.dart';

final splashStateProvider = StateProvider<bool>((ref) => false);

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _logoSlideAnimation;
  late AnimationController _shineController;
  late AnimationController _textController;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late AnimationController _bgController;
  bool _navigated = false;
  bool _splashTriggered = false;

  @override
  void dispose() {
    _logoController.dispose();
    _shineController.dispose();
    _textController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoController.forward();

    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutBack),
    );
    Future.delayed(const Duration(milliseconds: 900), () {
      _textController.forward();
    });

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(splashStateProvider, (previous, next) {
      if (next == true && !_navigated) {
        _navigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        });
      }
    });

    // Trigger splash state after 3 seconds (only once)
    if (!_splashTriggered) {
      _splashTriggered = true;
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          ref.read(splashStateProvider.notifier).state = true;
        }
      });
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Animated vertical gradient background
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary,
                      AppColors.secondary,
                      AppColors.background,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: child,
              );
            },
          ),
          // Animated geometric waves/curves
          _buildAnimatedWaves(size),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(),
                const SizedBox(height: 40),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: FadeTransition(
                    opacity: _textFadeAnimation,
                    child: Text(
                      'Atmiya Vidhya Dham',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            color: AppColors.secondary.withOpacity(0.18),
                            blurRadius: 16,
                            offset: const Offset(0, 2),
                          ),
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedWaves(Size size) {
    // Two animated geometric waves/curves using brand colors
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        final t = _bgController.value;
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: size.height * 0.62 + 30 * math.sin(t * 2 * math.pi),
              child: CustomPaint(
                size: Size(size.width, 120),
                painter: _WavePainter(
                  color: AppColors.secondary.withOpacity(0.18),
                  amplitude: 24 + 12 * math.sin(t * 2 * math.pi),
                  yOffset: 60,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: size.height * 0.68 + 20 * math.cos(t * 2 * math.pi),
              child: CustomPaint(
                size: Size(size.width, 100),
                painter: _WavePainter(
                  color: AppColors.primary.withOpacity(0.13),
                  amplitude: 18 + 8 * math.cos(t * 2 * math.pi),
                  yOffset: 40,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return SlideTransition(
      position: _logoSlideAnimation,
      child: FadeTransition(
        opacity: _logoFadeAnimation,
        child: Transform(
          alignment: Alignment.center,
          transform:
          Matrix4.identity()
            ..scale(1.08)
            ..setEntry(3, 2, 0.001)
            ..rotateY(-0.10), // slight 3D tilt
          child: Container(
            width: 380,
            height: 380,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.22),
                  blurRadius: 64,
                  spreadRadius: 16,
                  offset: const Offset(0, 32),
                ),
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.18),
                  blurRadius: 32,
                  spreadRadius: 8,
                  offset: const Offset(-16, 16),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 24,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                Image.asset(
                  'assets/hsh1.png',
                  width: 360,
                  height: 360,
                  fit: BoxFit.contain,
                ),
                // Animated diagonal shine sweep
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shineController,
                    builder: (context, _) {
                      final shinePos = _shineController.value;
                      return CustomPaint(painter: _ShinePainter(shinePos));
                    },
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

class _WavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double yOffset;
  _WavePainter({
    required this.color,
    required this.amplitude,
    required this.yOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
    Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    path.moveTo(0, yOffset);
    for (double x = 0; x <= size.width; x += 1) {
      path.lineTo(
        x,
        yOffset + amplitude * math.sin((x / size.width) * 2 * math.pi),
      );
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.yOffset != yOffset;
  }
}

class _ShinePainter extends CustomPainter {
  final double shinePos;
  _ShinePainter(this.shinePos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
    Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1.0 + 2 * shinePos, -1.0),
        end: Alignment(1.0 + 2 * shinePos, 1.0),
        colors: [
          Colors.white.withOpacity(0.0),
          AppColors.surface.withOpacity(0.18),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.35, 0.5, 0.65],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _ShinePainter oldDelegate) {
    return oldDelegate.shinePos != shinePos;
  }
}