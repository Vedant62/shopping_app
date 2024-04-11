import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';

import '../models/category.dart';
import '../models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();
  String _enteredName = '';
  int _enteredQuantity = 1;
  var _selectedCategory = categories[Categories.dairy]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https('flutter-demo-f2d20-default-rtdb.firebaseio.com',
          'shopping-app.json');
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _enteredName,
            'quantity': _enteredQuantity,
            'category': _selectedCategory.title,
          }));
      print(response.body);
      print(response.statusCode);
      print(response.bodyBytes);
      print(response.headers);

      if(!context.mounted){
        return;
      }
      Navigator.of(context).pop(
      //   GroceryItem(
      //     id: DateTime.now().toString(),
      //     name: _enteredName,
      //     quantity: _enteredQuantity,
      //     category: _selectedCategory,
      //   ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 40,
                  decoration: InputDecoration(label: Text('Item name')),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().length <= 1) {
                      return 'Must be between 1 and 50';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _enteredName = value!;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(label: Text('Quantity')),
                        keyboardType: TextInputType.number,
                        initialValue: '1',
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              int.tryParse(value) == null ||
                              int.tryParse(value)! <= 0) {
                            return 'Must be a valid positive number';
                          }
                        },
                        onSaved: (value) {
                          _enteredQuantity = int.tryParse(value!)!;
                        },
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField(
                          value: _selectedCategory,
                          decoration: InputDecoration(label: Text('Category')
                              // fillColor: Colors.transparent
                              ),
                          items: [
                            for (final category in categories.entries)
                              DropdownMenuItem(
                                  value: category.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 16,
                                        width: 16,
                                        color: category.value.color,
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      Text(category.value.title)
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          }),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            _formKey.currentState!.reset();
                          },
                          child: Text('Reset')),
                      ElevatedButton(
                          onPressed: _saveItem, child: Text('Submit'))
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
