import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class AddExpenseDialog extends StatefulWidget {
  final Function(String, double, Category, DateTime) onAdd;

  const AddExpenseDialog({super.key, required this.onAdd});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.food;
  DateTime _selectedDate = DateTime.now();

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount == null || enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid title and amount (>0)')),
      );
      return;
    }

    widget.onAdd(enteredTitle, enteredAmount, _selectedCategory, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Expense'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<Category>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: Category.values.map((cat) {
                return DropdownMenuItem(value: cat, child: Text(cat.name));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: Text('Date: ${DateFormat('yMd').format(_selectedDate)}')),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choose Date', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submitData, child: const Text('Add Expense')),
      ],
    );
  }
}
