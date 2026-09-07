import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/expense.dart';
import 'widgets/summary_dashboard.dart';
import 'widgets/budget_section.dart';
import 'widgets/expense_card.dart';
import 'widgets/add_expense_dialog.dart';

void main() {
  runApp(const SmartExpenseTrackerApp());
}

class SmartExpenseTrackerApp extends StatelessWidget {
  const SmartExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ExpenseTrackerHome(),
    );
  }
}

class ExpenseTrackerHome extends StatefulWidget {
  const ExpenseTrackerHome({super.key});

  @override
  State<ExpenseTrackerHome> createState() => _ExpenseTrackerHomeState();
}

class _ExpenseTrackerHomeState extends State<ExpenseTrackerHome> {
  final List<Expense> _allExpenses = [];
  double _budget = 0;
  String _selectedFilter = 'All';
  Category? _selectedCategoryFilter;

  // Logic: Add Expense
  void _addExpense(String title, double amount, Category category, DateTime date) {
    setState(() {
      _allExpenses.add(Expense(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        category: category,
        date: date,
      ));
    });
  }

  // Logic: Delete Expense
  void _deleteExpense(String id) {
    setState(() {
      _allExpenses.removeWhere((expense) => expense.id == id);
    });
  }

  // Logic: Set Budget
  void _setBudget(double budget) {
    setState(() {
      _budget = budget;
    });
  }

  // Filtered Expenses
  List<Expense> get _filteredExpenses {
    DateTime now = DateTime.now();
    return _allExpenses.where((expense) {
      if (_selectedFilter == 'Today') {
        return expense.date.day == now.day &&
            expense.date.month == now.month &&
            expense.date.year == now.year;
      } else if (_selectedFilter == 'This Week') {
        DateTime weekStart = now.subtract(Duration(days: now.weekday - 1));
        return expense.date.isAfter(weekStart.subtract(const Duration(seconds: 1)));
      } else if (_selectedFilter == 'This Month') {
        return expense.date.month == now.month && expense.date.year == now.year;
      } else if (_selectedFilter == 'By Category' && _selectedCategoryFilter != null) {
        return expense.category == _selectedCategoryFilter;
      }
      return true; // All
    }).toList();
  }

  // Calculations
  double get _totalExpense => _filteredExpenses.fold(0, (sum, item) => sum + item.amount);
  
  double get _todayTotal {
    DateTime now = DateTime.now();
    return _allExpenses.where((e) => 
      e.date.day == now.day && e.date.month == now.month && e.date.year == now.year
    ).fold(0, (sum, item) => sum + item.amount);
  }

  double get _highestExpense => _filteredExpenses.isEmpty 
      ? 0 
      : _filteredExpenses.map((e) => e.amount).reduce((a, b) => a > b ? a : b);

  double get _lowestExpense => _filteredExpenses.isEmpty 
      ? 0 
      : _filteredExpenses.map((e) => e.amount).reduce((a, b) => a < b ? a : b);

  double get _averageExpense => _filteredExpenses.isEmpty ? 0 : _totalExpense / _filteredExpenses.length;

  Map<Category, double> get _categoryTotals {
    Map<Category, double> totals = {
      Category.food: 0,
      Category.transport: 0,
      Category.shopping: 0,
      Category.other: 0,
    };
    for (var expense in _filteredExpenses) {
      totals[expense.category] = (totals[expense.category] ?? 0) + expense.amount;
    }
    return totals;
  }

  String get _spendingStatus {
    if (_budget <= 0) return 'No Budget Set';
    double percent = (_totalExpense / _budget) * 100;
    if (percent < 50) return 'Safe';
    if (percent <= 80) return 'Moderate';
    if (percent <= 100) return 'Warning';
    return 'Over Budget';
  }

  Color get _statusColor {
    switch (_spendingStatus) {
      case 'Safe': return Colors.green;
      case 'Moderate': return Colors.orange;
      case 'Warning': return Colors.redAccent;
      case 'Over Budget': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Expense Tracker'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value.startsWith('Category:')) {
                setState(() {
                  _selectedFilter = 'By Category';
                  _selectedCategoryFilter = Category.values.firstWhere(
                    (c) => c.name == value.split(': ')[1]
                  );
                });
              } else {
                setState(() {
                  _selectedFilter = value;
                  _selectedCategoryFilter = null;
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All')),
              const PopupMenuItem(value: 'Today', child: Text('Today')),
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuDivider(),
              ...Category.values.map((c) => PopupMenuItem(
                value: 'Category: ${c.name}',
                child: Text('Category: ${c.name}'),
              )),
            ],
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BudgetSection(
              budget: _budget,
              remaining: _budget - _totalExpense,
              status: _spendingStatus,
              statusColor: _statusColor,
              onUpdateBudget: _setBudget,
            ),
            SummaryDashboard(
              total: _totalExpense,
              today: _todayTotal,
              highest: _highestExpense,
              lowest: _lowestExpense,
              average: _averageExpense,
              categoryTotals: _categoryTotals,
              filterTitle: _selectedFilter == 'By Category' 
                  ? 'Filter: ${_selectedCategoryFilter?.name}' 
                  : 'Filter: $_selectedFilter',
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Recent Expenses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            _filteredExpenses.isEmpty
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No expenses found for this filter.'),
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = _filteredExpenses[index];
                      return ExpenseCard(
                        expense: expense,
                        onDelete: () => _deleteExpense(expense.id),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddExpenseDialog(onAdd: _addExpense),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
