import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/database/app_database.dart';

class ChartsScreen extends StatelessWidget {
  final database = AppDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spending Analysis')),
      body: StreamBuilder<List<TransactionsData>>(
        stream: database.watchAllTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final transactions = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildPieChart(transactions),
                const SizedBox(height: 30),
                _buildBarChart(transactions),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPieChart(List<TransactionsData> txs) {
    final categoryTotals = <String, double>{};
    for (var t in txs) {
      if (t.type == 0) {
        categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
      }
    }
    return SizedBox(
      height: 250,
      child: PieChart(PieChartData(
        sections: categoryTotals.entries
            .map((e) => PieChartSectionData(
                  value: e.value,
                  title: '${e.key}\n\$${e.value.toStringAsFixed(0)}',
                ))
            .toList(),
      )),
    );
  }

  Widget _buildBarChart(List<TransactionsData> txs) {
    final monthlyExpenses = <int, double>{};
    for (var t in txs) {
      if (t.type == 0) {
        monthlyExpenses[t.date.month] = (monthlyExpenses[t.date.month] ?? 0) + t.amount;
      }
    }
    return SizedBox(
      height: 250,
      child: BarChart(BarChartData(
        barGroups: monthlyExpenses.entries
            .map((e) => BarChartGroupData(x: e.key, barRods: [
                  BarChartRodData(toY: e.value, color: Colors.blue),
                ]))
            .toList(),
      )),
    );
  }
}
