import 'package:flutter/material.dart';
import 'MenuItem.dart';

class CartScreen extends StatelessWidget {
  final List<MenuItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Shopping Cart',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            for (MenuItem item in cartItems)
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Description: ${item.description}'),
                    Text('Price: \$${item.price.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                checkout();
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  // ... rest of the code

  double calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void checkout() async {
    // Replace with the actual user ID
    var userId = 1;

    // Prepare order details
    var orderDetails = {
      'user_id': userId,
      'total_price': calculateTotal(),
      'cart_items': cartItems.map((item) => {
        'item_id': item.itemId,
        'quantity': 1, // Replace with the actual quantity if needed
        'price': item.price,
      }).toList(),
    };

    // Send the order to the server
    // ... (Your code for sending the order to the server)
  }
}
