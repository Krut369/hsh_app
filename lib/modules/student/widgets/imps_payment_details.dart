import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/font.dart';
import '../../../core/utils/responsive_util.dart';
import '../../../providers/payment_provider.dart';
import '../../../widgets/account_detail_row.dart';
import 'payment_proof_upload.dart';

class ImpsPaymentDetails extends ConsumerWidget {
  const ImpsPaymentDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentData = ref.watch(paymentProvider);
    final impsDetails = paymentData.impsDetails;

    final padding = ResponsiveUtil.responsivePadding(context);
    final spacing = ResponsiveUtil.verticalSpacing(context);
    final headingFontSize = ResponsiveUtil.responsiveFontSize(context, 22);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'IMPS Account Information',
            style: AppFonts.heading2(context).copyWith(
              fontSize: headingFontSize,
            ),
          ),
          SizedBox(height: spacing),

          // 🧠 Safely read IMPS details with fallback
          AccountDetailRow(
            label: 'Bank Name',
            value: impsDetails['Bank Name'] ?? 'N/A',
          ),
          AccountDetailRow(
            label: 'Account Holder Name',
            value: impsDetails['Account Holder Name'] ?? 'N/A',
          ),
          AccountDetailRow(
            label: 'Account Number',
            value: impsDetails['Account Number'] ?? 'N/A',
          ),
          AccountDetailRow(
            label: 'IFSC Code',
            value: impsDetails['IFSC Code'] ?? 'N/A',
          ),

          SizedBox(height: spacing * 1.5),
          const PaymentProofUploadSection(
            title: 'Upload IMPS Payment Proof',
            description: 'Please upload a screenshot of your IMPS payment for verification.',
          ),
        ],
      ),
    );
  }
}
