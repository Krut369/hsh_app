import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_text.dart';
import '../../../../core/constants/font.dart';
import '../../../../core/utils/responsive_util.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class ComplainFeedbackScreen extends ConsumerStatefulWidget {
  const ComplainFeedbackScreen({super.key});

  @override
  ConsumerState<ComplainFeedbackScreen> createState() =>
      _ComplainFeedbackScreenState();
}

class _ComplainFeedbackScreenState
    extends ConsumerState<ComplainFeedbackScreen> {
  final _feedbackController = TextEditingController();
  double _rating = 3;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final verticalSpacing =
        SizedBox(height: ResponsiveUtil.verticalSpacing(context));
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complaint Feedback',
          style: AppFonts.heading2(context).copyWith(
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authController.logout();
            },
          ),
        ],
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rate the service:", style: AppFonts.bodyMedium(context)),
            Slider(
              value: _rating,
              onChanged: (value) => setState(() => _rating = value),
              divisions: 4,
              min: 1,
              max: 5,
              label: _rating.toStringAsFixed(0),
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.3),
            ),
            verticalSpacing,
            TextField(
              controller: _feedbackController,
              decoration: InputDecoration(
                labelText: 'Write your feedback',
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: Theme.of(context).inputDecorationTheme.border,
                focusedBorder:
                    Theme.of(context).inputDecorationTheme.focusedBorder,
                enabledBorder:
                    Theme.of(context).inputDecorationTheme.enabledBorder,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              style: AppFonts.bodyRegular(context),
              maxLines: 3,
            ),
            verticalSpacing,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save feedback logic here
                  Navigator.popUntil(
                      context, ModalRoute.withName('/complain/home'));
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child:
                    Text(AppText.submit, style: AppFonts.buttonText(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
