import 'package:flutter/material.dart';

import '../utils/responsive_util.dart';

class AppFonts {
  // Headings
  static TextStyle heading1(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 24),
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle heading2(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 20),
    fontWeight: FontWeight.w700,
    color: Colors.black87,
  );

  static TextStyle heading3(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 18),
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  // New Headings to match Material Design typography
  static TextStyle headline6(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 20), // Often corresponds to heading2 or a slightly smaller heading
    fontWeight: FontWeight.w500, // Typically medium weight for headline6
    color: Colors.black,
  );

  // Subtitles
  static TextStyle subtitle1(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 16), // Common size for subtitle1
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  // Body
  static TextStyle bodyRegular(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 14),
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodyMedium(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 14),
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle bodyBold(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 14),
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  // Small / Caption
  static TextStyle smallText(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 12),
    color: Colors.grey[700],
  );

  // Buttons
  static TextStyle buttonText(BuildContext context) => TextStyle(
    fontSize: ResponsiveUtil.responsiveFontSize(context, 14),
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}