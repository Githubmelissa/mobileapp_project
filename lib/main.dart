import 'package:flutter/material.dart';
import 'HomeScreen.dart'; // Assuming your HomeScreen is in a 'screens' directory
import 'LoginPage.dart';
import 'SignupPage.dart'; // Assuming your SignupPage is in a 'screens' directory

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}
