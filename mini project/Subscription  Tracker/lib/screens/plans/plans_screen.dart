import 'package:flutter/material.dart';

class PlansScreen extends StatelessWidget {
  PlansScreen({super.key});

  // ✅ Example data - replace this with Firestore or API data later
  final List<Map<String, dynamic>> plans = [
    {
      'name': 'Basic Plan',
      'price': '\$9.99 / month',
      'features': [
        '1 user account',
        '5 GB cloud storage',
        'Email support'
      ]
    },
    {
      'name': 'Premium Plan',
      'price': '\$19.99 / month',
      'features': [
        '5 user accounts',
        '100 GB cloud storage',
        'Priority support'
      ]
    },
    {
      'name': 'Enterprise Plan',
      'price': '\$49.99 / month',
      'features': [
        'Unlimited accounts',
        '1 TB cloud storage',
        'Dedicated support'
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Plans'),
        backgroundColor: Colors.indigo,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plans.length,
        itemBuilder: (context, i) {
          final plan = plans[i]; // 👈 Now plan is a Map<String, dynamic>

          return Card(
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    plan['price'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate((plan['features'] as List).length, (index) {
                    return Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          (plan['features'] as List)[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Subscribed to ${plan['name']}!')),
                      );
                    },
                    child: const Text('Choose Plan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
