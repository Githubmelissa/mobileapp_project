import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() {
    return _AdminPanelState();
  }
}

class _AdminPanelState extends State<AdminPanel> {
  List<String> menuItems = []; // List to store menu items
  List<String> selectedItems = []; // List to store selected items in the order

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
                Tab(text: 'Make Order'),
              ],
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildAddMenuItemTab(),
                  _buildMakeOrderTab(),
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
            decoration: InputDecoration(
              labelText: 'Item Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextField(
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
              setState(() {
                menuItems.add(
                    'New Item'); // Replace with actual logic to add the item
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item added to the menu'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            child: Text('Add Item'),
          ),
          SizedBox(height: 20),
          Text(
            'Current Menu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(menuItems[index]),
                );
              },
            ),
          ),
        ],
      ),
    )  );
  }

  Widget _buildMakeOrderTab() {

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
            'Make Order',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Select Items:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          // Build a list of checkboxes for menu items
          SizedBox(
            height: 200, // Adjust the height as needed
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(
                    menuItems[index],
                    style: TextStyle(fontSize: 16),
                  ),
                  value: selectedItems.contains(menuItems[index]),
                  onChanged: (value) {
                    setState(() {
                      if (value != null && value) {
                        selectedItems.add(menuItems[index]);
                      } else {
                        selectedItems.remove(menuItems[index]);
                      }
                    });
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Handle order submission logic
              if (selectedItems.isNotEmpty) {
                // Replace this with your actual logic for submitting the order
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Order submitted successfully!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please select items to order.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
            child: Text('Submit Order'),
          ),
        ],
          )),
    );
  }
}
