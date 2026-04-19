import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart' as ui;
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/modules/student/features/payment/controllers/payment_controller.dart';
import 'payment_proof_upload.dart';

class ImpsPaymentDetails extends GetView<PaymentController> {
  const ImpsPaymentDetails({super.key});

  @override
  Widget build(BuildContext context) {

    final padding = ResponsiveUtil.responsivePadding(context);
    final spacing = ResponsiveUtil.verticalSpacing(context);

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Obx(() {
        final paymentData = controller.paymentData.value;
        final impsDetails = paymentData.impsDetails;
        return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ui.ModernText(
            'IMPS Account Information',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.headerBlue,
          ),
          SizedBox(height: spacing),

          _buildDetailRow('Bank Name', impsDetails['Bank Name'] ?? 'N/A'),
          _buildDetailRow('Account Holder Name', impsDetails['Account Holder Name'] ?? 'N/A'),
          _buildDetailRow('Account Number', impsDetails['Account Number'] ?? 'N/A'),
          _buildDetailRow('IFSC Code', impsDetails['IFSC Code'] ?? 'N/A'),

          SizedBox(height: spacing * 1.5),
          const PaymentProofUploadSection(
            title: 'Upload IMPS Payment Proof',
            description: 'Please upload a screenshot of your IMPS payment for verification.',
          ),
        ],
      );
      }),
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

