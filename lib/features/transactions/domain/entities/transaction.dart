class Transaction {
  final String id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String? note;
  final String transactionDate;
  final String createdAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    this.note,
    required this.transactionDate,
    required this.createdAt,
  });
}
