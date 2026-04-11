import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../presentation/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        children: [
          // Premium Background (Consistent with Login)
          Positioned.fill(
            child: Image.asset(
              'assets/login_screen_bg.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          
          // Subtle Overlay for focus on central logo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.2),
                    Colors.white.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),

          // Main Logo Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLogo(controller),
                const SizedBox(height: 10),
                SlideTransition(
                  position: controller.textSlideAnimation,
                  child: FadeTransition(
                    opacity: controller.textFadeAnimation,
                    child: Text(
                      'Atmiya Vidhya Dham',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.1,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
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

  Widget _buildLogo(SplashController controller) {
    return SlideTransition(
      position: controller.logoSlideAnimation,
      child: FadeTransition(
        opacity: controller.logoFadeAnimation,
        child: Hero(
          tag: 'app_logo',
          child: Container(
            width: 320,
            height: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 120,
                  spreadRadius: 30,
                ),
              ],
            ),
            child: Image.asset(
              'assets/Ai logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
