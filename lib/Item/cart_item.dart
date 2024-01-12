import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String path;
  final String name;
  final String price;
  final String origin;
  final int idx;

  CartItem({
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
        borderRadius: BorderRadius.circular(12)
      ),
      child: Center(
        child: 
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.network(
                    path,
                    height: 100.0,
                    width: 100.0,
                    fit: BoxFit.contain,
                    )
                ],
              ),

              Container(
                width: 150.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),

                    Text(
                      origin,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),

                    Row(children: [
                      Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(0, 0, 0, 1),width: 0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),child: IconButton(onPressed: () {

                      }, icon: Icon(Icons.remove)),),

                      SizedBox(width: 5.0,),
                      Text('1'),
                      SizedBox(width: 5.0,),

                      Container(decoration: BoxDecoration(
                        border: Border.all(color: Color.fromRGBO(0, 0, 0, 1),width: 0.1),
                        borderRadius: BorderRadius.circular(100)),child: IconButton(onPressed: () {

                      }, icon: Icon(Icons.add)),),
                    ],)
                  ],
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(50.0, 0, 0, 40.0),
                    child: IconButton(
                      onPressed: () {
                    
                      }, 
                      icon: Icon(
                        Icons.close
                      )
                    ),
                  ),
                  
                  Text(
                    ' ${price.toString()}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
