import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';

enum TransactionTypeEnum { income, expense }

class AddTransactionDialog extends StatefulWidget {
  final AppDatabase database;

  const AddTransactionDialog({required this.database, super.key});

  @override
  State<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Food';
  TransactionTypeEnum _transactionType = TransactionTypeEnum.expense;
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Food', 'Transportation', 'Entertainment',
    'Bills', 'Shopping', 'Healthcare', 'Education', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: _categories
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            Row(
              children: [
                Radio<TransactionTypeEnum>(
                  value: TransactionTypeEnum.expense,
                  groupValue: _transactionType,
                  onChanged: (val) => setState(() => _transactionType = val!),
                ),
                const Text('Expense'),
                Radio<TransactionTypeEnum>(
                  value: TransactionTypeEnum.income,
                  groupValue: _transactionType,
                  onChanged: (val) => setState(() => _transactionType = val!),
                ),
                const Text('Income'),
              ],
            ),
            ListTile(
              title: Text('Date: ${_selectedDate.toString().split(' ')[0]}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDate,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _saveTransaction, child: const Text('Save')),
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null) setState(() => _selectedDate = picked);
  }

  void _saveTransaction() async {
    if (_amountController.text.isEmpty) return;

    final entry = TransactionsCompanion(
      amount: Value(double.parse(_amountController.text)),
      category: Value(_selectedCategory),
      description: Value(_descriptionController.text),
      date: Value(_selectedDate),
      type: Value(_transactionType == TransactionTypeEnum.expense ? 0 : 1),
    );

    await widget.database.insertTransaction(entry);
    Navigator.pop(context);
  }
}
