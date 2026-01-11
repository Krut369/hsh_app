import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/core/constants/font.dart';
import 'package:hsh_app/core/utils/responsive_util.dart';
import 'package:hsh_app/providers/payment_provider.dart';
import 'package:hsh_app/modules/student/features/payment/payment_proof_upload.dart';

class UpiPaymentDetails extends ConsumerWidget {
  const UpiPaymentDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentData = ref.watch(paymentProvider);

    final padding = ResponsiveUtil.responsivePadding(context);
    final spacing = ResponsiveUtil.verticalSpacing(context);
    final imageSize = ResponsiveUtil.isMobile(context)
        ? 200.0
        : ResponsiveUtil.isTablet(context)
        ? 250.0
        : 300.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scan to pay',
            textAlign: TextAlign.center,
            style: AppFonts.heading2(context).copyWith(
              fontSize: ResponsiveUtil.responsiveFontSize(context, 22),
            ),
          ),
          SizedBox(height: spacing),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              paymentData.upiImageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: imageSize,
                height: imageSize,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: Icon(
                  Icons.broken_image,
                  size: ResponsiveUtil.responsiveIconSize(context, 48),
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(height: spacing),
          const PaymentProofUploadSection(
            title: 'Upload UPI Payment Proof',
            description: 'Please upload a screenshot of your UPI payment for verification.',
          ),
        ],
      ),
    );
  }
}
