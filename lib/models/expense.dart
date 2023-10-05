/// Import necessary packages and libraries
import 'package:uuid/uuid.dart'; // For generating unique IDs
import 'package:intl/intl.dart'; // For date formatting
import 'package:expense_tracker/widgets/category_page.dart';

/// Create a date formatter with the "month/day/year" format
final formatter = DateFormat.yMd();

/// Generate a UUID instance for generating unique IDs
const uuid = Uuid();

/// Define the 'Expense' class to represent individual expenses
class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4(); // Generate a unique ID for each expense

  final String id; // Unique ID for the expense
  final String title; // Title of the expense
  final double amount; // Amount spent
  final DateTime date; // Date of the expense
  final CategoryItem category; // Category of the expense

  /// Get the formatted date as a string
  String get formattedDate {
    return formatter.format(date);
  }
}

/// Define the 'ExpenseBucket' class to group expenses by category
class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
  });

  /// Create an 'ExpenseBucket' for a specific category from a list of all expenses
  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses
      .where((expense) => expense.category == category)
      .toList();

  final CategoryItem category; // Category of the expenses in this bucket
  final List<Expense> expenses; // List of expenses in this category

  /// Calculate the total expenses within this bucket
  double get totalExpenses {
    double sum = 0;

    for (final expense in expenses) {
      sum += expense.amount; // Calculate the sum of amounts
    }

    return sum;
  }
}