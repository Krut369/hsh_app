import 'package:flutter/material.dart';


import 'package:hsh_app/modules/student/features/payment/payment_details_screen.dart';

class PaymentMethodSheet extends StatelessWidget {
  const PaymentMethodSheet({super.key});

  void _onMethodSelected(BuildContext context, String method) {
    Navigator.pop(context); // Close the sheet
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsScreen(paymentMethod: method),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select Payment Method',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          _PaymentOptionTile(
            title: 'UPI',
            icon: Icons.qr_code_scanner,
            color: Colors.deepPurple,
            onTap: () => _onMethodSelected(context, 'UPI'),
          ),
          const SizedBox(height: 12),
          _PaymentOptionTile(
            title: 'NEFT',
            icon: Icons.account_balance,
            color: Colors.blue,
            onTap: () => _onMethodSelected(context, 'NEFT'),
          ),
          const SizedBox(height: 12),
          _PaymentOptionTile(
            title: 'IMPS',
            icon: Icons.bolt,
            color: Colors.orange,
            onTap: () => _onMethodSelected(context, 'IMPS'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _PaymentOptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _PaymentOptionTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
