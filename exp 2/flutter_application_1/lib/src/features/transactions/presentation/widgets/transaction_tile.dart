import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';

class TransactionTile extends StatelessWidget {
  final TransactionsData transaction;

  const TransactionTile({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transaction.type == 0 ? Colors.red : Colors.green,
          child: Icon(
            transaction.type == 0 ? Icons.remove : Icons.add,
            color: Colors.white,
          ),
        ),
        title: Text(transaction.description),
        subtitle: Text('${transaction.category} • ${_formatDate(transaction.date)}'),
        trailing: Text(
          '\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.type == 0 ? Colors.red : Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
