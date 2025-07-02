import 'package:flutter/material.dart';
import '../../../widgets/payment_method_tile.dart';
import '../widgets/upi_payment_details.dart';
import '../widgets/neft_payment_details.dart';
import '../widgets/imps_payment_details.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const PaymentMethodTile(
            icon: Icons.qr_code,
            title: 'UPI Payment',
            child: UpiPaymentDetails(),
          ),
          PaymentMethodTile(
            icon: Icons.account_balance,
            title: 'NEFT Payment',
            child: NeftPaymentDetails(),
          ),
          const PaymentMethodTile(
            icon: Icons.compare_arrows,
            title: 'IMPS Payment',
            child: ImpsPaymentDetails(),
          ),
        ]),
      ),
    );
  }
}
