import 'package:app_thuong_mai/screen/cart_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartItem extends StatefulWidget {

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

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
    final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();
  
  static get quantity => null;

  void updateStatus() async {
    try{
      await _databaseReference.child('users/${widget.userToken}').child('cats/${widget.idx}').update({
        'status':false,
      });
    }
    catch(e){
      e.toString();
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
                (context as Element).reassemble();
                resetScreen();
              },
              child: Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void resetScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CartScreen(userToken: widget.userToken)),
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
                  widget.path,
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
                    widget.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0
                    ),
                  ),

                  Text(
                    widget.origin,
                    style: const TextStyle(
                      fontSize: 16.0
                    ),
                  ),

                  Row(children: [
                    Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color.fromRGBO(0, 0, 0, 1),width: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),child: IconButton(onPressed: () {
                      int.parse(widget.quantity.toString()) + 1;
                    }, icon: const Icon(Icons.remove)),),

                    const SizedBox(width: 5.0,),

                    Text(
                      widget.quantity.toString(), 
                      style: const TextStyle(fontSize: 18),
                    ),

                    const SizedBox(width: 5.0,),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 1),
                        width: 0.1
                      ),
                      borderRadius: BorderRadius.circular(100)),
                      child: IconButton(
                        onPressed: () {
                          int.parse(widget.quantity.toString()) - 1;
                    }, icon: const Icon(Icons.add)),),
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
                      setState(() {
                        deleteProduct(context);
                      });
                    }, 
                    icon: const Icon(
                      Icons.close
                    )
                  ),
                ),
                
                Text(
                  widget.price.toString(),
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ],
            )
          ],
        )
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}