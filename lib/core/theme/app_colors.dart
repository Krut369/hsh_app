import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Secondary Palette
  static const Color primary = Color(0xFF1E3A8A); // Deep Royal Navy
  static const Color primaryLight = Color(0xFF3B82F6); // Vibrant Blue
  static const Color primaryDark = Color(0xFF1E293B); // Slate Dark
  static const Color secondary = Color(0xFF0EA5E9); // Electric Sky

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x33FFFFFF), Color(0x1AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background & Surface
  static const Color background = Color(0xFFF8FAFC); // Clean slate background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0F172A);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderSubtle = Color(0xFFF1F5F9);

  // Status & Feedback Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color pendingBlue = Color(0xFF3B82F6);
  static const Color resolvedGreen = Color(0xFF10B981);
  static const Color reviewOrange = Color(0xFFF97316);
  static const Color cancelledRed = Color(0xFFEF4444);
  static const Color requestedGrey = Color(0xFF94A3B8);

  // Semantic Aliases
  static const Color success = successGreen;
  static const Color warning = warningOrange;
  static const Color info = pendingBlue;
  static const Color error = cancelledRed;
  static const Color headerBlue = Color(0xFF0F172A);
  static const Color mainBackground = Color(0xFFF8FAFC);

  // Base colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
