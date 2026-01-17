class LaundryCost {
  final double washPrice;
  final double pressPrice;
  final double bothPrice;

  LaundryCost({
    required this.washPrice,
    required this.pressPrice,
    required this.bothPrice,
  });

  LaundryCost copyWith({
    double? washPrice,
    double? pressPrice,
    double? bothPrice,
  }) {
    return LaundryCost(
      washPrice: washPrice ?? this.washPrice,
      pressPrice: pressPrice ?? this.pressPrice,
      bothPrice: bothPrice ?? this.bothPrice,
    );
  }
}
