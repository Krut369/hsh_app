class PaymentData {
  final String upiImageUrl;
  final Map<String, String> neftDetails;
  final Map<String, String> impsDetails;

  const PaymentData({
    required this.upiImageUrl,
    required this.neftDetails,
    required this.impsDetails,
  });

  factory PaymentData.initial() => PaymentData(
    upiImageUrl: 'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg',
    neftDetails: {
      'Bank Name': 'Example Bank PLC',
      'Account Holder Name': 'John Doe',
      'Account Number': '123456789012345',
      'IFSC Code': 'EXMP0001234',
    },
    impsDetails: {
      'Bank Name': 'Another Bank Corp',
      'Account Holder Name': 'Jane Smith',
      'Account Number': '987654321098765',
      'IFSC Code': 'ANOT0005678',
    },
  );
}
