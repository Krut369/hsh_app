import 'package:flutter/material.dart';

/// Utility class to handle responsive layout
class ResponsiveUtil {
  static const mobileMaxWidth = 599.0;
  static const tabletMinWidth = 600.0;
  static const tabletMaxWidth = 1023.0;
  static const desktopMinWidth = 1024.0;

  static double _width(BuildContext context) => MediaQuery.of(context).size.width;

  /// Check if device is Mobile
  static bool isMobile(BuildContext context) => _width(context) <= mobileMaxWidth;

  /// Check if device is Tablet
  static bool isTablet(BuildContext context) =>
      _width(context) >= tabletMinWidth && _width(context) <= tabletMaxWidth;

  /// Check if device is Desktop
  static bool isDesktop(BuildContext context) => _width(context) >= desktopMinWidth;

  /// Responsive padding with max limit
  static double responsivePadding(BuildContext context) {
    final width = _width(context);
    if (isMobile(context)) return 12.0;
    if (isTablet(context)) return 20.0;
    return width * 0.05 > 64.0 ? 64.0 : width * 0.05;
  }

  /// Responsive font size based on base value
  static double responsiveFontSize(BuildContext context, double base) {
    final width = _width(context);
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.1;
    return base * 1.2;
  }

  /// Responsive vertical spacing
  static double verticalSpacing(BuildContext context) {
    if (isMobile(context)) return 12;
    if (isTablet(context)) return 16;
    return 20;
  }

  /// Responsive horizontal spacing
  static double horizontalSpacing(BuildContext context) {
    if (isMobile(context)) return 8;
    if (isTablet(context)) return 12;
    return 16;
  }

  /// Responsive grid count for cards
  static int responsiveGridCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  /// Responsive icon size based on base value
  static double responsiveIconSize(BuildContext context, double base) {
    final width = _width(context);
    if (isMobile(context)) return base;
    if (isTablet(context)) return base * 1.1;
    return base * 1.2;
  }

}
