import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  int userToken;
  final int total;
  final String ddmmyy;

  Orders({
    super.key,
    required this.userToken,
    required this.ddmmyy,
    required this.total
  });

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    try {
      return Column(
        children: [
          Text(
            widget.total.toString(),
            style: TextStyle(color: Colors.black),
          ),
          Text(
            widget.ddmmyy,
            style: TextStyle(color: Colors.black),
          ),
        ],
      );
    } catch (e) {
      return Text("Error: $e");
    }
  }
}