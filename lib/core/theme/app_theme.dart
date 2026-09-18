import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
      letterSpacing: 0.2,
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.surface,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.05),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(AppColors.primary.toARGB32(), {
      50: AppColors.surface,
      100: AppColors.surface,
      200: AppColors.background,
      300: AppColors.background,
      400: AppColors.secondary,
      500: AppColors.primary,
      600: AppColors.primary,
      700: AppColors.textPrimary,
      800: AppColors.textPrimary,
      900: AppColors.textPrimary,
    }),
    backgroundColor: AppColors.background,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: AppColors.error,
    onError: Colors.white,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      elevation: 3,
      shadowColor: AppColors.primary.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        letterSpacing: 0.3,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryLight,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: Colors.white,
    elevation: 6,
    shape: const CircleBorder(),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.primary,
    size: 24.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    labelStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border, width: 1.2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.error, width: 2.5),
    ),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 40),
    displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 32),
    displaySmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 28),
    headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 24),
    headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 20),
    titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
    titleMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
    titleSmall: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500, fontSize: 14),
    bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    bodySmall: TextStyle(color: AppColors.textMuted, fontSize: 12),
    labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
    labelMedium: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    labelSmall: TextStyle(color: AppColors.textMuted, fontSize: 11),
  ),
);
