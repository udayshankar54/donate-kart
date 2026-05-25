class PaymentModel {
  final String id;
  final String donorId;
  final double amount;
  final String currency;
  final String status;
  final String paymentMethod;
  final String? transactionId;

  PaymentModel({
    required this.id,
    required this.donorId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
  });
}
