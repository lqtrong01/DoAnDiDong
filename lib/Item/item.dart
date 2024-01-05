import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String path;
  final String name;
  final String price;

  const Item({
    Key? key,
    required this.path,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 150.0,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            path,
            height: 60.0,
            width: 60.0,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8.0),
          Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 16.0,),
                Text(
                  name ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ),
          Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Price: ${price ?? ''}',
                ),
                Icon(
                  Icons.add_box_outlined,
                  color: Colors.green[300],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
