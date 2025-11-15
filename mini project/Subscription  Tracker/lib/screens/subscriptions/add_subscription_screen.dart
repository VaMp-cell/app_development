import 'package:flutter/material.dart';
import '../../../models/subscription_model.dart';
import '../../../services/subscription_service.dart';
import '../../../services/auth_service.dart'; // <-- ADD THIS IMPORT

class AddSubscriptionScreen extends StatefulWidget {
  final SubscriptionModel? existingSub;
  const AddSubscriptionScreen({super.key, this.existingSub});

  @override
  State<AddSubscriptionScreen> createState() => _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  String _selectedCategory = 'Entertainment';
  final _formKey = GlobalKey<FormState>();
  final _service = SubscriptionService();

  @override
  void initState() {
    super.initState();
    if (widget.existingSub != null) {
      _nameCtrl.text = widget.existingSub!.name;
      _priceCtrl.text = widget.existingSub!.price.toString();
      _dateCtrl.text = widget.existingSub!.date;
      _selectedCategory = widget.existingSub!.category;
    }
  }

  Future<void> _saveSubscription() async {
    if (!_formKey.currentState!.validate()) return;

    // get logged in user data
    final userData = await AuthService().getUserData();
    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in again.')),
      );
      return;
    }

    // check subscription limit
    final count = await _service.getSubscriptionCount();
    if (userData['isPremium'] == false && count >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upgrade to Premium to add more than 2 subscriptions!'),
        ),
      );
      return;
    }

    final newSub = SubscriptionModel(
      id: widget.existingSub?.id,
      name: _nameCtrl.text.trim(),
      price: double.tryParse(_priceCtrl.text.trim()) ?? 0.0,
      date: _dateCtrl.text.trim(),
      category: _selectedCategory,
    );

    try {
      if (widget.existingSub == null) {
        await _service.addSubscription(newSub);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription added successfully!')),
        );
      } else {
        await _service.updateSubscription(newSub);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscription updated successfully!')),
        );
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving subscription: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingSub == null ? "Add Subscription" : "Edit Subscription"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Subscription Name'),
                validator: (v) => v!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                controller: _dateCtrl,
                decoration: const InputDecoration(labelText: 'Billing Date'),
                validator: (v) => v!.isEmpty ? 'Enter date' : null,
              ),
              DropdownButtonFormField(
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: 'Entertainment', child: Text('Entertainment')),
                  DropdownMenuItem(value: 'Education', child: Text('Education')),
                  DropdownMenuItem(value: 'Productivity', child: Text('Productivity')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                onChanged: (value) => setState(() => _selectedCategory = value!),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveSubscription,
                child: Text(widget.existingSub == null ? "Save" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
