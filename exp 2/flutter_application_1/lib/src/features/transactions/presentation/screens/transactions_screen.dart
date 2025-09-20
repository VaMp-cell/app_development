import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';
import '../widgets/transaction_tile.dart';

class TransactionsScreen extends StatelessWidget {
  final database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: StreamBuilder<List<TransactionsData>>(
        stream: database.watchAllTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final transactions = snapshot.data!;
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions yet.'));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (_, i) => TransactionTile(transaction: transactions[i]),
          );
        },
      ),
    );
  }
}
