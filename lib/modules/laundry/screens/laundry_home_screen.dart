import 'package:flutter/material.dart';

import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';

class LaundryHomeScreen extends StatelessWidget {
  const LaundryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));

    return Scaffold(
      appBar: AppBar(title: Text('My Laundry', style: AppFonts.heading2(context))),
      body: Padding(
        padding: padding,
        child: ListView.builder(
          itemCount: 3, // Replace with your actual data list length
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Laundry Request #${index + 1}', style: AppFonts.bodyMedium(context)),
                subtitle: Text('Status: In Progress', style: AppFonts.smallText(context)),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.pushNamed(context, '/laundry/detail');
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
