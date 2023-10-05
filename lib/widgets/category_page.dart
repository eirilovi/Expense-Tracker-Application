/// Import necessary packages and libraries
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

/// Define the 'CategoryPage' class as a StatefulWidget
class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key, required this.onRemoveCategory});

  /// Callback function to handle category removal
  final void Function(CategoryItem categoryItem) onRemoveCategory;

  @override
  State<CategoryPage> createState() {
    return _CategoryPageState();
  }
}

/// Define the 'CategoryItem' class to represent a category
class CategoryItem {
  final String category;
  final IconData icon;

  CategoryItem(this.category, this.icon);
}

/// Initialize a list of 'CategoryItem' objects
List<CategoryItem> categoryItems = [
  CategoryItem("Food", Icons.lunch_dining),
  CategoryItem("Travel", Icons.flight_takeoff),
  CategoryItem("Leisure", Icons.movie),
  CategoryItem("Work", Icons.work),
];

/// Define the state class for 'CategoryPage'
class _CategoryPageState extends State<CategoryPage> {
  /// Function to add a new category to the list
  void _addNewCategory(String newCategory) {
    setState(() {
      categoryItems.add(
        CategoryItem(newCategory, _icon!.icon as IconData),
      );
    });
  }

  Icon? _icon;

  /// Function to open the icon picker dialog
  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.cupertino]);

    _icon = Icon(icon);
    setState(() {});

    debugPrint('Picked Icon:  $icon');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Category'),
      ),
      body: ListView.builder(
        itemCount: categoryItems.length,
        itemBuilder: (context, index) => Dismissible(
          key: ValueKey<CategoryItem>(categoryItems[index]),
          child: ListTile(
            leading: Icon(categoryItems[index].icon),
            title: Text(categoryItems[index].category.toString().split('.').last),
            onTap: () {
              // Can add a function to edit the category name if I want later
            },
          ),
          onDismissed: (direction) {
            if (categoryItems[index] != categoryItems[0]) {
              widget.onRemoveCategory(categoryItems[index]);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog or a form to allow users to add a new category
          showDialog(
            context: context,
            builder: (context) {
              String newCategoryName = ''; // Store the user's input
              return AlertDialog(
                title: const Text('Add Category'),
                content: TextField(
                  onChanged: (value) {
                    // Capture the user's input for the new category name
                    newCategoryName = value;
                  },
                ),
                actions: [
                  ElevatedButton(
                    onPressed: _pickIcon,
                    child: const Text('Open IconPicker'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (newCategoryName.isNotEmpty &&
                          newCategoryName.length < 17) {
                        // Add the new CategoryItem to the list
                        _addNewCategory(newCategoryName);
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}