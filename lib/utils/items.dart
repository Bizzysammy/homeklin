import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Item {
  final String name;
  final IconData icon;

  Item(this.name, this.icon);
}

class Order {
  final String name;
  final String productName;
  final double amount;

  Order({
    required this.name,
    required this.productName,
    required this.amount,
  });
}

// Create a list of orders
final List<Order> orders = [
  Order(name: 'Order #1', productName: 'Product A', amount: 10000),
  Order(name: 'Order #2', productName: 'Product B', amount: 15000),
  Order(name: 'Order #3', productName: 'Product C', amount: 20000),
  Order(name: 'Order #4', productName: 'Product D', amount: 25000),
  Order(name: 'Order #5', productName: 'Product E', amount: 30000),
  Order(name: 'Order #6', productName: 'Product F', amount: 35000),
];
final List<Color> leadingColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.orange,
  Colors.purple,
];

class YourDataModel {
  final String name;
  final String transactionLocation;
  final bool isPaid;

  YourDataModel({
    required this.name,
    required this.transactionLocation,
    required this.isPaid,
  });
}

// Create a list of your data
List<YourDataModel> yourData = [
  YourDataModel(
    name: 'John Doe',
    transactionLocation: 'Training in New York',
    isPaid: true,
  ),
  YourDataModel(
    name: 'Alice Smith',
    transactionLocation: 'Training in Los Angeles',
    isPaid: false,
  ),
  YourDataModel(
    name: 'Bob Jones',
    transactionLocation: 'Training in Chicago',
    isPaid: true,
  ),
  YourDataModel(
    name: 'Jane Doe',
    transactionLocation: 'Training in Houston',
    isPaid: false,
  ),
  YourDataModel(
    name: 'John Smith',
    transactionLocation: 'Training in Philadelphia',
    isPaid: true,
  ),
];
