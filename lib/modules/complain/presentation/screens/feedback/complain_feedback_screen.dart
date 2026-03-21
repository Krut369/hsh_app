import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/auth/presentation/controllers/auth_controller.dart';

class ComplainFeedbackScreen extends StatefulWidget {
  const ComplainFeedbackScreen({super.key});

  @override
  State<ComplainFeedbackScreen> createState() => _ComplainFeedbackScreenState();
}

class _ComplainFeedbackScreenState extends State<ComplainFeedbackScreen> {
  final _feedbackController = TextEditingController();
  final authController = Get.find<AuthController>();
  double _rating = 3;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final verticalSpacing =
        SizedBox(height: ResponsiveUtil.verticalSpacing(context));

    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Feedback', style: AppFonts.heading2(context)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveUtil.responsivePadding(context)),
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
            ),
            verticalSpacing,
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                  labelText: 'Write your feedback',
                  border: OutlineInputBorder()),
              maxLines: 3,
            ),
            verticalSpacing,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                child: Text(AppText.submit,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
