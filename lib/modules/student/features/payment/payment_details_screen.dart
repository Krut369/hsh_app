import 'package:flutter/material.dart';


import 'package:hsh_app/modules/student/features/payment/imps_payment_details.dart';
import 'package:hsh_app/modules/student/features/payment/neft_payment_details.dart';
import 'package:hsh_app/modules/student/features/payment/upi_payment_details.dart';

import 'package:hsh_app/widgets/custom_app_bar.dart';

class PaymentDetailsScreen extends StatelessWidget {
  final String paymentMethod;

  const PaymentDetailsScreen({
    super.key,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    switch (paymentMethod) {
      case 'UPI':
        content = const UpiPaymentDetails();
        break;
      case 'NEFT':
        content = const NeftPaymentDetails();
        break;
      case 'IMPS':
        content = const ImpsPaymentDetails();
        break;
      default:
        content = const Center(child: Text('Unknown Payment Method'));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: '$paymentMethod Payment',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: content,
      ),
    );
  }
}
