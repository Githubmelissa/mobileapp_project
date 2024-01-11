import 'package:flutter/material.dart';
import 'MenuItem.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  final List<MenuItem> cartItems;

  const CartScreen({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<int> quantities; // List to store quantities for each item

  @override
  void initState() {
    super.initState();
    quantities = List.generate(widget.cartItems.length, (index) => widget.cartItems[index].quantity);
  }

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
            for (int i = 0; i < widget.cartItems.length; i++)
              CartItemWidget(
                item: widget.cartItems[i],
                quantity: quantities[i],
                onQuantityChanged: (newQuantity) {
                  setState(() {
                    quantities[i] = newQuantity;
                  });
                },
              ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                checkout(context);
              },
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }

  double calculateTotal() {
    double total = 0;
    for (int i = 0; i < widget.cartItems.length; i++) {
      total += widget.cartItems[i].price * quantities[i];
    }
    return total;
  }

  Future<void> checkout(BuildContext context) async {
    // Calculate total price
    double totalPrice = calculateTotal();

    // Show a dialog to confirm the total price to the user
    bool confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm Order'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total Price: \$${totalPrice.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Text('Do you want to place the order?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled the order
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed the order
              },
              child: Text('Place Order'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // User confirmed the order, proceed with checkout

      // Prepare order details
      var orderDetails = {
        'total_price': totalPrice,
        'cart_items': List.generate(widget.cartItems.length, (index) {
          return {
            'item_id': widget.cartItems[index].itemId,
            'quantity': quantities[index],
            'price': widget.cartItems[index].price,
          };
        }),
      };

      // Send the order to the server
      final response = await http.post(
        Uri.parse('http://127.0.0.1/food/place_order.php'),
        body: jsonEncode(orderDetails),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Order placed successfully
        print('Order placed successfully');

        // Clear the cart (optional)
        widget.cartItems.clear();

        // Navigate to a confirmation screen or home screen
        Navigator.pop(context); // Close the cart screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order placed successfully'),
          ),
        );
      } else {
        // Failed to place the order
        print('Failed to place the order. Status Code: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to place the order. Please try again.'),
          ),
        );
      }
    }
  }

}

class CartItemWidget extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text('Description: ${item.description}'),
          Text('Price: \$${item.price.toStringAsFixed(2)}'),
          Row(
            children: [
              Text('Quantity: '),
              DropdownButton<int>(
                value: quantity,
                items: List.generate(10, (index) => index + 1)
                    .map((value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                ))
                    .toList(),
                onChanged: (newValue) {
                  onQuantityChanged(newValue!);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
