import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_app/data/categories.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _formKey = GlobalKey<FormState>();

  void _saveItem(){
    _formKey.currentState!.validate();
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
                  ),
                ),
                Expanded(
                  child: DropdownButtonFormField(
                      decoration: InputDecoration(
                        label: Text('Category')
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
                      onChanged: (value) {}),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: () {
                    _formKey.currentState!.reset();
                  }, child: Text('Reset')),
                  ElevatedButton(onPressed: _saveItem, child: Text('Submit'))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
