import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/payment_model.dart';

class PaymentNotifier extends StateNotifier<PaymentData> {
  PaymentNotifier() : super(PaymentData.initial());
}

final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentData>((ref) {
  return PaymentNotifier();
});
