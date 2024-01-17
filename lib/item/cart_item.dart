import 'dart:js';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {

    final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  int userToken;
  final String path;
  final String name;
  final String price;
  final String origin;
  final int quantity;
  bool status = true;
  final int idx;

  CartItem({
    Key? key,
    required this.userToken,
    required this.path,
    required this.name,
    required this.price,
    required this.origin,
    required this.quantity,
    required this.status,
    required this.idx,
  }) : super(key: key);

  void updateStatus() async {
    try{
      await _databaseReference.child('users/${userToken}').child('cats/${idx}').update({
        'status':false,
      });
    }
    catch(e){

    }
  }

  // Xuất thông báo xóa sản phẩm ra khỏi giỏ hàng
  void deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận xóa sản phẩm ra khỏi giỏ hàng'),
          content: Text('Bạn có muốn xóa sản phẩm hay không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                updateStatus();
                Navigator.pop(context);
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image.network(
                  path,
                  height: 60.0,
                  width: 60.0,
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
                    Text(quantity.toString()),
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
                    onPressed: (){
                      deleteProduct(context);
                    }, 
                    icon: Icon(
                      Icons.close
                    )
                  ),
                ),
                
                Text(
                  price.toString(),
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