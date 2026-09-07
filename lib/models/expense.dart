enum Category {
  food,
  transport,
  shopping,
  other;

  String get name {
    switch (this) {
      case Category.food:
        return 'Food';
      case Category.transport:
        return 'Transport';
      case Category.shopping:
        return 'Shopping';
      case Category.other:
        return 'Other';
    }
  }
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final Category category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });
}
