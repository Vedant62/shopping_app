import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_items.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import '../data/categories.dart';
import '../models/grocery_item.dart';
import 'grocery_item_tile.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  bool _isLoading = true;
  List<GroceryItem> _groceryItems = [];
  void loadItems() async {
    final url = Uri.https('flutter-demo-f2d20-default-rtdb.firebaseio.com',
        'shopping-app.json');
    final res = await http.get(url);
    if(res.body=='null'){
      setState(() {
        _isLoading=false;
      });
      return;
    }
    final Map<String, dynamic> listData = json.decode(res.body);
    final List<GroceryItem> _loadedItems = [];

    for(final item in listData.entries){
      final category = categories.entries.firstWhere((element) => element.value.title == item.value['category']);
      _loadedItems.add(GroceryItem(id: item.key, name: item.value['name'], quantity: item.value['quantity'], category: category.value));
    }
    setState(() {
      _groceryItems = _loadedItems;
    });

  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadItems();
  }
  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),


    );


    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
    // loadItems();
  }

  void _removeItem(GroceryItem item) {
    final url = Uri.https('flutter-demo-f2d20-default-rtdb.firebaseio.com',
        'shopping-app/${item.id}.json');
    http.delete(url);
    setState(() {
      _groceryItems.remove(item);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(child: Text('No items added yet'),);

    if(_isLoading){
      content = Center(child: CircularProgressIndicator(),);
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
          child: ListTile(
            title: Text(_groceryItems[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryItems[index].category.color,
            ),
            trailing: Text(
              _groceryItems[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Your groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: content,
    );
  }
}
