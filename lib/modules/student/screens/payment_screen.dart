import 'package:flutter/material.dart';

import '../../../core/constants/app_text.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../widgets/custom_button.dart';
import '../widgets/payment_components.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = ResponsiveUtil.responsivePadding(context);
    final vertical = ResponsiveUtil.verticalSpacing(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FE),
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppText.feesAndPayments,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Summary Cards
            Row(
              children: const [
                Expanded(
                  child: SummaryCard(
                    title: AppText.totalBill,
                    amount: '\$1,200.00',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: SummaryCard(
                    title: AppText.amountPaid,
                    amount: '\$800.00',
                    amountColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: vertical),

            // 2. Pending Balance
            const BalanceCard(
              amount: '\$400.00',
              date: 'Oct 31, 2023',
            ),
            SizedBox(height: vertical * 1.5),

            // 3. Pay Now Button
            CustomButton(
              text: AppText.payNow,
              onPressed: () {
                // Show payment sheet or navigation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing payment...')),
                );
              },
              backgroundColor: const Color(0xFF1976D2), // Strong blue
              borderRadius: 25,
            ),
            SizedBox(height: vertical * 1.5),

            // 4. Payment History Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppText.paymentHistory,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    AppText.viewAll,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: vertical),

            // 5. Payment Transaction List
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                TransactionTile(
                  title: 'Monthly Rent - Oct',
                  date: 'Oct 12, 2023 • Visa **** 4242',
                  amount: '\$450.00',
                  isSuccess: true,
                  icon: Icons.apartment,
                  iconColor: Colors.blue.shade700,
                  iconBgColor: Colors.blue.shade50,
                ),
                TransactionTile(
                  title: 'Meal Subscription',
                  date: 'Oct 05, 2023 • Apple Pay',
                  amount: '\$250.00',
                  isSuccess: true,
                  icon: Icons.restaurant,
                  iconColor: Colors.blue.shade700,
                  iconBgColor: Colors.blue.shade50,
                ),
                TransactionTile(
                  title: 'Laundry Service',
                  date: 'Sep 28, 2023 • Bank Transfer',
                  amount: '\$100.00',
                  isSuccess: false,
                  icon: Icons.local_laundry_service,
                  iconColor: Colors.blueGrey.shade700,
                  iconBgColor: Colors.blueGrey.shade50,
                ),
                TransactionTile(
                  title: 'Internet Charges',
                  date: 'Sep 25, 2023 • Visa **** 4242',
                  amount: '\$45.00',
                  isSuccess: true,
                  icon: Icons.wifi,
                  iconColor: Colors.blue.shade700,
                  iconBgColor: Colors.blue.shade50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
