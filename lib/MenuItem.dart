import 'dart:convert';
import 'package:flutter/material.dart';


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
