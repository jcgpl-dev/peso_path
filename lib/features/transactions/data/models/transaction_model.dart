import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  const TransactionModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.amount,
    required super.type,
    required super.category,
    super.note,
    required super.transactionDate,
    required super.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      amount: map['amount'],
      type: map['type'],
      category: map['category'],
      note: map['note'],
      transactionDate: map['transaction_date'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'note': note,
      'transaction_date': transactionDate,
      'created_at': createdAt,
    };
  }
}
