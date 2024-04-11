import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_items.dart';
class GroceryItemTile extends StatelessWidget {
  const GroceryItemTile({super.key, required this.index});
  final int index;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(groceryItems[index].name),
      leading: Container(
        width: 24,
        height: 24,
        color: groceryItems[index].category.color,
      ),
      trailing: Text(groceryItems[index].quantity.toString()),
    );
  }
}
