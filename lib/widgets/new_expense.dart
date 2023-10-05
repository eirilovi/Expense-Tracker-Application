/// Import necessary packages and the 'Expense' model
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/category_page.dart';

/// Define the 'NewExpense' class, which is a StatefulWidget
class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  /// Callback function to handle adding an expense
  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

/// Define the private state class '_NewExpenseState' for 'NewExpense'
class _NewExpenseState extends State<NewExpense> {
  /// Controllers for text input fields
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  /// Selected date and category
  DateTime? _selectedDate;
  CategoryItem _selectedCategory = categoryItems[0];

  /// Function to present a date picker dialog
  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _removeCategory(CategoryItem category) {
    final categoryIndex = categoryItems.indexOf(category);
    if (categoryIndex > 0) {
      setState(() {
        categoryItems.remove(category);
      });
    }
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Category deleted.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              categoryItems.insert(categoryIndex, category);
            });
          },
        ),
      ),
    );
  }

  /// Function to submit expense data
  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    /// Check for invalid input and show an alert dialog if necessary
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
              'Please make sure a valid title, amount, date, and category were entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    /// Call the 'onAddExpense' callback with the new expense data
    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory,
      ),
    );

    /// Close the NewExpense overlay
    Navigator.pop(context);
  }

  /// Dispose of controllers when the widget is removed
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Build method to create the widget hierarchy
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [
          // Text input field for expense title
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              // Text input field for expense amount
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Amount'),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Add a small horizontal space
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Display the selected date or 'No date selected'
                    Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(
                        Icons.calendar_month,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // Add a small vertical space
          Row(
            children: [
              // Dropdown button for selecting expense category
              DropdownButton(
                value: _selectedCategory,
                items: categoryItems
                    .map(
                      (category) => DropdownMenuItem(
                    value: category,
                    child: Text(
                        category.category
                    ),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.edit,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) => CategoryPage(onRemoveCategory: _removeCategory))
                  );
                },
              ),
              const Spacer(), // Create a flexible space between elements
              TextButton(
                onPressed: () {
                  // Cancel adding a new expense and close the overlay
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: _submitExpenseData,
            child: const Text('Save Expense'),
          ),
        ],
      ),
    );
  }
}