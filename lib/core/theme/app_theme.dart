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
    elevation: 4,
    shadowColor: Colors.black26,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(AppColors.primary.value, {
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
    accentColor: AppColors.secondary,
    backgroundColor: AppColors.background,
  ).copyWith(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimary,
    onBackground: AppColors.textPrimary,
    surface: AppColors.surface,
    onSurface: AppColors.textPrimary,
    error: Colors.redAccent,
    onError: Colors.white,

    // onSurfaceVariant: AppColors.successGreen,
    // onInverseSurface: AppColors.warningOrange,
  ),
  cardTheme: CardThemeData(
    color: AppColors.card,
    elevation: 6,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      textStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.secondary,
    foregroundColor: AppColors.textPrimary,
    elevation: 8,
    shape: CircleBorder(),
  ),
  iconTheme: const IconThemeData(
    color: AppColors.primary,
    size: 26.0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    labelStyle: const TextStyle(color: AppColors.primary),
    hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.7)),
    contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.primary, width: 2.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.redAccent, width: 3),
    ),
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 57),
    displayMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 45),
    displaySmall: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 36),
    headlineMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 32),
    headlineSmall: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 28),
    titleLarge: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
        fontSize: 22),
    titleMedium: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 16),
    titleSmall: TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w500,
        fontSize: 14),
    bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
    bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
    bodySmall: TextStyle(
        color: AppColors.textSecondary.withOpacity(0.8), fontSize: 12),
    labelLarge: const TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
    labelMedium: TextStyle(color: AppColors.textSecondary, fontSize: 12),
    labelSmall: TextStyle(
        color: AppColors.textSecondary.withOpacity(0.6), fontSize: 11),
  ),
);
