import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'MenuItem.dart';
import 'cart_screen.dart';
class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<MenuItem>> futureMenuItems;
  List<MenuItem> cartItems = [];

  @override
  void initState() {
    super.initState();
    futureMenuItems = fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: FutureBuilder<List<MenuItem>>(
        future: futureMenuItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No menu items available'),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      MenuItem menuItem = snapshot.data![index];
                      return ListTile(
                        title: Text(menuItem.name),
                        subtitle: Text(menuItem.description),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('\$${menuItem.price.toStringAsFixed(2)}'),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                addToCart(menuItem);
                              },
                              child: Text('Add to Cart'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    navigateToCart();
                  },
                  child: Text('View Cart'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  // ... rest of the code

  void addToCart(MenuItem item) {
    setState(() {
      cartItems.add(item);
    });
  }

  void navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }

  Future<List<MenuItem>> fetchMenuItems() async {
    final response = await http.get(
        Uri.parse('http://127.0.0.1/food/get_menu_items.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load menu items');
    }
  }
}
