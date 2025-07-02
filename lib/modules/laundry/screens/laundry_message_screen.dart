import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/auth_provider.dart';

class LaundryMessageScreen extends ConsumerWidget {
  const LaundryMessageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final padding = EdgeInsets.all(ResponsiveUtil.responsivePadding(context));
    final authNotifier = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text('Messages', style: AppFonts.heading2(context).copyWith(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authNotifier.logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: padding,
        child: ListView(
          children: [
            ListTile(
              title: Text("Admin", style: AppFonts.bodyBold(context)),
              subtitle: Text("Your laundry is picked up.", style: AppFonts.bodyRegular(context)),
            ),
            ListTile(
              title: Text("Admin", style: AppFonts.bodyBold(context)),
              subtitle: Text("Delivery expected by tomorrow.", style: AppFonts.bodyRegular(context)),
            ),
          ],
        ),
      ),
    );
  }
}
