import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_theme.dart';

/// A provider that holds the current theme.
final themeProvider = Provider<ThemeData>((ref) {
  return appTheme; // You can swap this with a darkTheme if needed
});
