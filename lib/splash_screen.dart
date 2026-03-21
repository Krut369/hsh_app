import "package:hsh_app/core/enums/user_role.dart";
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_colors.dart';
import 'modules/auth/presentation/controllers/auth_controller.dart';
import 'modules/auth/presentation/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller and pass context for go_router
    final controller = Get.put(SplashController(context));
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Animated vertical gradient background
          AnimatedBuilder(
            animation: controller.bgController,
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
          _buildAnimatedWaves(size, controller),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(controller),
                const SizedBox(height: 40),
                SlideTransition(
                  position: controller.textSlideAnimation,
                  child: FadeTransition(
                    opacity: controller.textFadeAnimation,
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

  Widget _buildAnimatedWaves(Size size, SplashController controller) {
    return AnimatedBuilder(
      animation: controller.bgController,
      builder: (context, child) {
        final t = controller.bgController.value;
        return Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: size.height * 0.62 + 30 * math.sin(t * 2 * math.pi),
              child: CustomPaint(
                size: Size(size.width, 120),
                painter: WavePainter(
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
                painter: WavePainter(
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

  Widget _buildLogo(SplashController controller) {
    return SlideTransition(
      position: controller.logoSlideAnimation,
      child: FadeTransition(
        opacity: controller.logoFadeAnimation,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(1.08, 1.08, 1.0)
            ..setEntry(3, 2, 0.001)
            ..rotateY(-0.10),
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
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: controller.shineController,
                    builder: (context, _) {
                      final shinePos = controller.shineController.value;
                      return CustomPaint(painter: ShinePainter(shinePos));
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

class WavePainter extends CustomPainter {
  final Color color;
  final double amplitude;
  final double yOffset;
  WavePainter({
    required this.color,
    required this.amplitude,
    required this.yOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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
  bool shouldRepaint(covariant WavePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.amplitude != amplitude ||
        oldDelegate.yOffset != yOffset;
  }
}

class ShinePainter extends CustomPainter {
  final double shinePos;
  ShinePainter(this.shinePos);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
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
  bool shouldRepaint(covariant ShinePainter oldDelegate) {
    return oldDelegate.shinePos != shinePos;
  }
}
