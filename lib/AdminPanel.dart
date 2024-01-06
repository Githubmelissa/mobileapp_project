import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() {
    return _AdminPanelState();
  }
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin panel'),
      ),
      body: Center(
        child: Text('Design your admin panel here.'),
      ),
    );
  }
}