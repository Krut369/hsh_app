import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/providers/payment_provider.dart';
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
          const ui.ModernText(
            'Bank Account Details',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
          const SizedBox(height: 16),
          if (data.isNotEmpty)
            ...data.entries
                .map((e) => _buildDetailRow(e.key, e.value))
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: ui.ModernText(
                'No NEFT details available.',
                fontSize: 14,
                color: Colors.grey,
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ui.ModernText(
            label,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          ui.ModernText(
            value,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
        ],
      ),
    );
  }
}

