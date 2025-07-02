import 'package:flutter/material.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.home, style: AppFonts.heading2(context)),
        centerTitle: true,
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
        child: Center(
          child: Text(
            AppText.welcomeMessage,
            style: AppFonts.heading3(context),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
