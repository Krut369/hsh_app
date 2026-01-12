import 'package:flutter/material.dart';

import '../core/constants/font.dart';

class AccountDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const AccountDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppFonts.smallText(context)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SelectableText(
                  value,
                  style: AppFonts.bodyMedium(context),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}
