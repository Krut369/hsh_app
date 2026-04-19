import 'package:flutter/material.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;

import 'package:hsh_app/modules/student/features/payment/imps_payment_details.dart';
import 'package:hsh_app/modules/student/features/payment/neft_payment_details.dart';
import 'package:hsh_app/modules/student/features/payment/upi_payment_details.dart';

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

    return ui.ModernScaffold(
      backgroundColor: Colors.white,
      appBar: ui.ModernAppBar(
        title: '$paymentMethod Payment',
      ),
      body: SingleChildScrollView(
        child: content,
      ),
    );
  }
}

