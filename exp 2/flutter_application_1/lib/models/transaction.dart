class Transaction {
  final int? id;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final TransactionType type; // income or expense
  final List<String>? labels;

  Transaction({
    this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
    required this.type,
    this.labels,
  });
}

enum TransactionType { income, expense }
