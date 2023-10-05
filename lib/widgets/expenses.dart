/// Import necessary packages and widgets
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/category_page.dart';

/// Define the 'Expenses' class, which is a StatefulWidget
class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}
/// Define the private state class '_ExpensesState' for 'Expenses'
class _ExpensesState extends State<Expenses> {
  /// Initialize a list to store registered expenses
  final List<Expense> _registeredExpenses = [
    Expense(
      title: 'Flutter Course',
      amount: 19.99,
      date: DateTime.now(),
      category: categoryItems[3],
    ),
    Expense(
      title: 'Cinema',
      amount: 15.69,
      date: DateTime.now(),
      category: categoryItems[2],
    ),
  ];

  /// Function to open the add expense overlay
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  /// Function to add an expense to the list
  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  /// Function to remove an expense from the list
  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  /// Build method to create the widget hierarchy
  @override
  Widget build(BuildContext context) {
    // Initialize the main content as a message when there are no expenses
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );

    /// Update the main content when there are registered expenses
    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    /// Build and return the scaffold with the app bar and body
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker'),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          // Display a chart widget with the registered expenses
          Chart(expenses: _registeredExpenses),
          // Expand the remaining space with the main content
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
