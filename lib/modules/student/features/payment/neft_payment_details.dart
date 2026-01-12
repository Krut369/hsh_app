import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/providers/payment_provider.dart';
import 'package:hsh_app/widgets/account_detail_row.dart';
import 'payment_proof_upload.dart';

class NeftPaymentDetails extends ConsumerWidget {
  const NeftPaymentDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(paymentProvider).neftDetails;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bank Account Details',
            style: AppFonts.heading2(context),
          ),
          const SizedBox(height: 16),
          if (data.isNotEmpty)
            ...data.entries
                .map((e) => AccountDetailRow(label: e.key, value: e.value))
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'No NEFT details available.',
                style: AppFonts.bodyRegular(context),
              ),
            ),
          const SizedBox(height: 24),
          const PaymentProofUploadSection(
            title: 'Upload NEFT Payment Proof',
            description:
                'Please upload a screenshot of your NEFT payment for verification.',
          ),
        ],
      ),
    );
  }
}
