import 'package:flutter/material.dart';
import '../../../core/constants/app_text.dart';
import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../widgets/complain_card.dart';

class ComplainHomeScreen extends StatelessWidget {
  const ComplainHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final verticalSpacing = SizedBox(height: ResponsiveUtil.verticalSpacing(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Complaints',
          style: AppFonts.heading2(context),
        ),
      ),
      body: Padding(
        padding: padding,
        child: ListView.separated(
          itemCount: 3, // Replace with actual list length
          separatorBuilder: (_, __) => verticalSpacing,
          itemBuilder: (context, index) {
            return ComplainCard(
              title: "Leaking Pipe",
              status: AppText.pending,
              onTap: () {
                Navigator.pushNamed(context, '/complain/detail');
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Raise Complaint Screen
        },
        child: const Icon(Icons.add),
        tooltip: 'Raise Complaint',
      ),
    );
  }
}
