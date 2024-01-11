import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Order.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() {
    return _AdminPanelState();
  }
}

class _AdminPanelState extends State<AdminPanel> {
  List<String> menuItems = []; // List to store menu items
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemPriceController = TextEditingController();
  TextEditingController itemDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Add Menu Item'),
                Tab(text: 'View Orders'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAddMenuItemTab(),
                  _buildViewOrdersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMenuItemTab() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/newitem.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add New Item to Menu',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: itemNameController,
              decoration: InputDecoration(
                labelText: 'Item Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: itemDescriptionController,
              decoration: InputDecoration(
                labelText: 'Item Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: itemPriceController,
              decoration: InputDecoration(
                labelText: 'Item Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add the new item to the menu
                addMenuItem();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
              child: Text('Add Item'),
            ),
            // ... (existing code)
          ],
        ),
      ),
    );
  }

  Widget _buildViewOrdersTab() {
    return FutureBuilder<List<Order>>(
      future: fetchOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No orders available.');
        } else {
          // Orders fetched successfully, display them
          List<Order> orders = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/make.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'View Orders',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Orders:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Build a list of orders
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            'Order ID: ${orders[index].orderId}\n'
                                'User ID: ${orders[index].userId}\n'
                                'Total Price: \$${orders[index].totalPrice}\n'
                                'Delivery Address: ${orders[index].deliveryAddress}\n'
                                'Order Status: ${orders[index].orderStatus}\n'
                                'Order Date: ${orders[index].orderDate}',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

Future<List<Order>> fetchOrders() async {
  final response = await http.get(Uri.parse('http://127.0.0.1/food/get_orders.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);

    // Convert the JSON data to a list of Order objects
    List<Order> orders = data.map((json) {
      return Order(
        orderId: json['order_id'],
        userId: json['user_id'],
        totalPrice: json['total_price'],
        deliveryAddress: json['delivery_address'],
        orderStatus: json['order_status'],
        orderDate: json['order_date'],
      );
    }).toList();

    return orders;
  } else {
    throw Exception('Failed to load orders');
  }
}
  void addMenuItem() async {
    final itemName = itemNameController.text;
    final itemPrice = itemPriceController.text;
    final itemDescription= itemDescriptionController.text;
    if (itemName.isNotEmpty && itemPrice.isNotEmpty) {
      final response = await http.post(
        Uri.parse('http://127.0.0.1/food/add_menu_item.php'),
        body: {
          'item_name': itemName,
          'item_description': itemDescription,
          'item_price': itemPrice,
        },
      );


      print('Response from PHP: ${response.body}');

      if (response.statusCode == 200) {
        // Item added successfully
        setState(() {
          menuItems.add(itemName);
          itemNameController.clear();
          itemPriceController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item added to the menu'),
          ),
        );
      } else {
        // Failed to add item
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item. Please try again.'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter item name and price.'),
        ),
      );
    }
  }

}
