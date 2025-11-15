import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const SubscriptionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(data['name']),
        subtitle: Text("${data['period']} plan"),
        trailing: Text("₹${data['amount']}"),
      ),
    );
  }
}
