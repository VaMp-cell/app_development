import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/subscription_service.dart';
import '../../models/subscription_model.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = SubscriptionService();

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: StreamBuilder<List<SubscriptionModel>>(
        stream: service.getSubscriptions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final subs = snapshot.data ?? [];
          if (subs.isEmpty) {
            return const Center(child: Text('No subscriptions to analyze.'));
          }

          // 🔹 Calculate totals
          double total = 0;
          final Map<String, double> categoryTotals = {};

          for (var s in subs) {
            total += s.price;
            categoryTotals[s.category] =
                (categoryTotals[s.category] ?? 0) + s.price;
          }

          // 🔹 Define color palette
          final colors = [
            Colors.blue,
            Colors.red,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.teal,
            Colors.pink,
            Colors.amber,
          ];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Monthly Spend: ₹${total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // 🟢 Pie Chart
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: _generateSections(categoryTotals, colors),
                      sectionsSpace: 2,
                      centerSpaceRadius: 30,
                      borderData: FlBorderData(show: false),
                    ),
                    swapAnimationDuration:
                        const Duration(milliseconds: 800), // 🌀 smooth animation
                    swapAnimationCurve: Curves.easeInOut,
                  ),
                ),

                const SizedBox(height: 20),

                // 🟣 Legend
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: categoryTotals.entries.map((e) {
                    final index = categoryTotals.keys.toList().indexOf(e.key);
                    final color = colors[index % colors.length];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${e.key} (${e.value.toStringAsFixed(0)})',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔸 Helper function to create Pie Chart sections
  List<PieChartSectionData> _generateSections(
      Map<String, double> data, List<Color> colors) {
    int i = 0;
    return data.entries.map((e) {
      final color = colors[i % colors.length];
      i++;
      return PieChartSectionData(
        color: color,
        value: e.value,
        title: e.key,
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
