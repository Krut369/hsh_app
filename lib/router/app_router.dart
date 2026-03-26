import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';

// This file is now legacy and mostly serves to hold the RouterNotifier 
// if any parts of the app still rely on it during transition.
// However, most logic has moved to AuthMiddleware in app_pages.dart.

class RouterNotifier extends ChangeNotifier {
  RouterNotifier() {
    final authController = Get.find<AuthController>();
    authController.isAuthenticated.listen((_) => notifyListeners());
    authController.user.listen((_) => notifyListeners());
    authController.isLoading.listen((_) => notifyListeners());
    authController.error.listen((_) => notifyListeners());
  }
}
