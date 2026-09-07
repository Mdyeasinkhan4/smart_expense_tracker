import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseCard extends StatelessWidget {
  final Expense expense;
  final VoidCallback onDelete;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade100,
          child: Icon(_getIcon(expense.category), color: Colors.teal),
        ),
        title: Text(expense.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${expense.category.name} • ${DateFormat('yMMMd').format(expense.date)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('\$${expense.amount.toStringAsFixed(2)}', 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal)),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Expense'),
                    content: const Text('Are you sure you want to remove this expense?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                      TextButton(onPressed: () {
                        onDelete();
                        Navigator.pop(ctx);
                      }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(Category category) {
    switch (category) {
      case Category.food: return Icons.fastfood;
      case Category.transport: return Icons.directions_bus;
      case Category.shopping: return Icons.shopping_cart;
      case Category.other: return Icons.category;
    }
  }
}
