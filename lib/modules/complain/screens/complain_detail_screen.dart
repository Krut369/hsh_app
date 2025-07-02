import 'package:flutter/material.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';

class ComplainDetailScreen extends StatelessWidget {
  const ComplainDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final verticalSpacing = SizedBox(height: ResponsiveUtil.verticalSpacing(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.appTitle, style: AppFonts.heading2(context).copyWith(color: Colors.white)),
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card for Complaint Info
            Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title", style: AppFonts.bodyBold(context)),
                    Text("Leaking Pipe", style: AppFonts.bodyRegular(context)),
                    verticalSpacing,
                    Text("Category", style: AppFonts.bodyBold(context)),
                    Text("Plumbing", style: AppFonts.bodyRegular(context)),
                    verticalSpacing,
                    Text("Status", style: AppFonts.bodyBold(context)),
                    Text(AppText.pending, style: AppFonts.bodyRegular(context)),
                    verticalSpacing,
                    Text("Description", style: AppFonts.bodyBold(context)),
                    Text(
                      "Water is leaking continuously near the washbasin.",
                      style: AppFonts.bodyRegular(context),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/complain/feedback');
                },
                child: Text(AppText.submit, style: AppFonts.buttonText(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
