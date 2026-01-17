import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/laundry_cost_model.dart';

final laundryCostProvider = StateNotifierProvider<LaundryCostNotifier, LaundryCost>((ref) {
  return LaundryCostNotifier();
});

class LaundryCostNotifier extends StateNotifier<LaundryCost> {
  LaundryCostNotifier()
      : super(LaundryCost(
          washPrice: 10.0,
          pressPrice: 5.0,
          bothPrice: 15.0,
        ));

  void updateCosts({double? wash, double? press, double? both}) {
    state = state.copyWith(
      washPrice: wash,
      pressPrice: press,
      bothPrice: both,
    );
  }
}
