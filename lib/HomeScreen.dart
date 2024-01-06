import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'MenuScreen.dart';

class MenuItem {
  final String name;
  final String description;
  final double price;

  MenuItem({required this.name, required this.description, required this.price});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}

Future<List<MenuItem>> fetchMenuItems() async {
  final response = await http.get(Uri.parse('http://192.168.1.3/API/file.php'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((item) => MenuItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load menu items');
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<MenuItem>> futureMenuItems;

  @override
  void initState() {
    super.initState();
    futureMenuItems = fetchMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/bg.jpg', // Replace with your restaurant image path
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 40.0), // Adjust spacing from the top
              Text(
                'MF Restaurant',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'You chose the right way!',
                style: TextStyle(
                  fontSize: 18.0,
                  fontFamily: 'OpenSans', // Use a custom font if desired
                  color: Colors.white,
                ),
              ),
              Text(
                'Welcome to our MFdelivery',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Use a custom font if desired
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuScreen(),
                    ),
                  );
                },
                child: Text('Check Menu'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
