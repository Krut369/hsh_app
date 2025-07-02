import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/payment_data.dart';

class PaymentNotifier extends StateNotifier<PaymentData> {
  PaymentNotifier() : super(PaymentData.initial());
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentData>((ref) {
  return PaymentNotifier();
});
