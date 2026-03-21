import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/theme/app_theme.dart';

class ThemeController extends GetxController {
  final _isDarkMode = false.obs;

  ThemeData get theme =>
      appTheme; // Currently only one theme, can add logic for dark mode later

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    // Get.changeTheme(_isDarkMode.value ? darkTheme : lightTheme);
  }
}
