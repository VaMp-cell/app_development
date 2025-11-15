import 'package:flutter/material.dart';
import '../../../services/subscription_service.dart';
import '../../../models/subscription_model.dart';
import 'add_subscription_screen.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = SubscriptionService();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Subscriptions')),
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
            return const Center(child: Text('No subscriptions yet'));
          }

          return ListView.builder(
            itemCount: subs.length,
            itemBuilder: (context, i) {
              final sub = subs[i];
              return ListTile(
                title: Text(sub.name),
                subtitle: Text('₹${sub.price.toStringAsFixed(2)} • ${sub.category}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final id = sub.id ?? '';
                    await service.deleteSubscription(id);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${sub.name} deleted')),
                    );
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddSubscriptionScreen(existingSub: sub),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddSubscriptionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
