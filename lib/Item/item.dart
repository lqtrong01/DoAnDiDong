import 'package:app_thuong_mai/Item/detail_item.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String path;
  final String name;
  final String price;
  final String origin;
  final int idx;

  const Item({
    Key? key,
    required this.path,
    required this.name,
    required this.price,
    required this.origin,
    required this.idx,
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
            height: 50.0,
            width: 50.0,
            fit: BoxFit.contain,
          ),
          Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0,),
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ),
          Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0,),
                Text(
                  origin,
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
                  'Price: ${price.toString()}',
                ),
                IconButton(
                  onPressed: (){
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (BuildContext context) => DetailItem(idx: idx,)
                      )
                    );
                  },
                  icon: Icon(Icons.add_box_outlined),
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
