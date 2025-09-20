import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';

class BudgetScreen extends StatefulWidget {
  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final database = AppDatabase();
  double monthlyBudget = 2000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget')),
      body: StreamBuilder<List<TransactionsData>>(
        stream: database.watchAllTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
          final spent = _calculateMonthlySpent(snapshot.data!);
          final remaining = monthlyBudget - spent;
          final progress = spent / monthlyBudget;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress > 1 ? 1 : progress,
                  color: progress > 0.8 ? Colors.red : Colors.green,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 10),
                Text('Spent: \$${spent.toStringAsFixed(2)}'),
                Text('Remaining: \$${remaining.toStringAsFixed(2)}'),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateMonthlySpent(List<TransactionsData> txs) {
    final now = DateTime.now();
    return txs
        .where((t) => t.type == 0 && t.date.month == now.month && t.date.year == now.year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}
