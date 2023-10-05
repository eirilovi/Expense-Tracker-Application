/// Import necessary packages and the 'Expense' model
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

/// Define the 'ExpenseItem' class, which is a StatelessWidget
class ExpenseItem extends StatelessWidget {
  /// Constructor for 'ExpenseItem' that takes an 'expense' parameter
  const ExpenseItem(this.expense, {super.key});

  /// The 'expense' object that represents the expense data
  final Expense expense;

  /// Build method to create the widget hierarchy
  @override
  Widget build(BuildContext context) {
    /// Create a Card widget to display the expense details
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the expense title with custom text style
            Text(
              expense.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4), // Add a small vertical space
            Row(
              children: [
                // Display the expense amount formatted as currency
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                ),
                const Spacer(), // Create a flexible space between elements
                Row(
                  children: [
                    // Display the expense category icon
                    Icon(expense.category.icon),
                    const SizedBox(width: 8), // Add a small horizontal space
                    // Display the formatted date of the expense
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
