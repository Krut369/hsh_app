import 'package:flutter/material.dart';

import '../core/constants/font.dart';

class PaymentMethodTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget child;

  const PaymentMethodTile({
    super.key,
    required this.icon,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(
            title,
            style: AppFonts.heading2(context), // 🧠 Applying your custom font
          ),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [child],
        ),
      ),
    );
  }
}
