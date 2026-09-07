import 'package:flutter/material.dart';
import '../models/expense.dart';

class SummaryDashboard extends StatelessWidget {
  final double total;
  final double today;
  final double highest;
  final double lowest;
  final double average;
  final Map<Category, double> categoryTotals;
  final String filterTitle;

  const SummaryDashboard({
    super.key,
    required this.total,
    required this.today,
    required this.highest,
    required this.lowest,
    required this.average,
    required this.categoryTotals,
    required this.filterTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(filterTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                Text('Total: \$${total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            _buildStatRow('Today\'s Total', today),
            _buildStatRow('Highest Expense', highest),
            _buildStatRow('Lowest Expense', lowest),
            _buildStatRow('Average Expense', average),
            const SizedBox(height: 12),
            const Text('Category Totals', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: Category.values.map((c) {
                return Chip(
                  label: Text('${c.name}: \$${(categoryTotals[c] ?? 0).toStringAsFixed(1)}'),
                  backgroundColor: Colors.teal.withOpacity(0.1),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('\$${value.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
