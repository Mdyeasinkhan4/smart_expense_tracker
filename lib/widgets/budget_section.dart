import 'package:flutter/material.dart';

class BudgetSection extends StatelessWidget {
  final double budget;
  final double remaining;
  final String status;
  final Color statusColor;
  final Function(double) onUpdateBudget;

  const BudgetSection({
    super.key,
    required this.budget,
    required this.remaining,
    required this.status,
    required this.statusColor,
    required this.onUpdateBudget,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController budgetController = TextEditingController(text: budget > 0 ? budget.toString() : '');

    return Card(
      margin: const EdgeInsets.all(12),
      color: Colors.teal.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Budget',
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    double? val = double.tryParse(budgetController.text);
                    if (val != null && val >= 0) {
                      onUpdateBudget(val);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid positive budget')),
                      );
                    }
                  },
                  child: const Text('Update'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Remaining Budget', style: TextStyle(fontSize: 14)),
                    Text('\$${remaining.toStringAsFixed(2)}', 
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, 
                      color: remaining < 0 ? Colors.red : Colors.black)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (remaining < 0)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Warning: Budget Exceeded!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}
