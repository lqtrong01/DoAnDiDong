

import 'package:flutter/material.dart';

class OrderPayItem extends StatelessWidget {
  final String path;
  final String name;
  final String price;
  final String origin;
  final int quantity;
  final bool status;
  final int idx;
  const OrderPayItem({
    super.key, 
    required this.path, 
    required this.name, 
    required this.origin,
    required this.quantity,
    required this.price,
    required this.status,
    required this.idx
  });
  double calculateTotal() {
    // Chuyển đổi giá trị price từ String sang double
    double priceValue = double.parse(price.replaceAll(',', ''));

    // Tính tổng tiền
    double total = quantity * priceValue;

    return total;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 0.1, color: const Color.fromRGBO(96, 96, 96, 1))
      ),
      child: Column(
        children: [
          ListTile(
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            leading: Image.network(path, width: 60, height: 60, fit: BoxFit.contain,),
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(origin),
            trailing: Container(child: Column(
              children: [
                Text('x$quantity'),
                Text(price, style: TextStyle(fontWeight: FontWeight.w500),)
              ],
            )),
          )
        ],
      ),
    );
  }
}