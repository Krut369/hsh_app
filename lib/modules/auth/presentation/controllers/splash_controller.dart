import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/enums/user_role.dart';
import 'auth_controller.dart';
import '../../../student/presentation/routes/student_routes.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController logoController;
  late Animation<double> logoFadeAnimation;
  late Animation<Offset> logoSlideAnimation;

  late AnimationController shineController;

  late AnimationController textController;
  late Animation<double> textFadeAnimation;
  late Animation<Offset> textSlideAnimation;

  late AnimationController bgController;

  @override
  void onInit() {
    super.onInit();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    logoFadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: logoController, curve: Curves.easeIn));
    logoSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(parent: logoController, curve: Curves.easeOutBack));
    logoController.forward();

    shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    textFadeAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));
    textSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(parent: textController, curve: Curves.easeOutBack));

    Future.delayed(const Duration(milliseconds: 900), () {
      textController.forward();
    });

    bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    _startSplashDelay();
  }

  void _startSplashDelay() {
    Future.delayed(const Duration(seconds: 2), () {
      final auth = Get.find<AuthController>();
      if (auth.isAuthenticated.value && auth.user.value != null) {
        final role = auth.user.value!.role;
        if (role == UserRole.laundry) {
          Get.offAllNamed('/laundry_module');
        } else if (role == UserRole.complain) {
          Get.offAllNamed('/complain_module');
        } else if (role == UserRole.leader) {
          Get.offAllNamed('/leader_module');
        } else {
          // Changed to student shell instead of profile directly
          Get.offAllNamed(StudentRoutes.shell); 
        }
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  void onClose() {
    logoController.dispose();
    shineController.dispose();
    textController.dispose();
    bgController.dispose();
    super.onClose();
  }
}
