import 'package:flutter/material.dart';

import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';

class LaundryDetailScreen extends StatelessWidget {
  const LaundryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final verticalSpacing = SizedBox(height: ResponsiveUtil.verticalSpacing(context));

    return Scaffold(
      appBar: AppBar(title: Text('Laundry Details', style: AppFonts.heading2(context))),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Laundry ID: 12345", style: AppFonts.bodyMedium(context)),
            verticalSpacing,
            Text("Requested On: 1 July 2025", style: AppFonts.bodyRegular(context)),
            verticalSpacing,
            Text("Status: In Progress", style: AppFonts.bodyRegular(context)),
            verticalSpacing,
            Text("Items: 3 Shirts, 2 Pants", style: AppFonts.bodyRegular(context)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/laundry/message');
                },
                child: Text("View Messages", style: AppFonts.buttonText(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
