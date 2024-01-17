import 'package:app_thuong_mai/Item/cart_item.dart';
import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final int userToken;
  const CartScreen({super.key, required this.userToken});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> user = [];
  List<dynamic> lst_cat = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user.add(value);
        });
        for(var value in user[widget.userToken]['cats']){
          lst_cat.add(value);
        }
        print(lst_cat);
        print(lst_cat.length);
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void tinhTien(){
    
  }

  // Thanh toán giỏ hàng
  void payNow(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác Nhận Thanh Toán"),
          content: Text("Bạn muốn thanh toán không?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {

                Navigator.of(context).pop();
              },
              child: Text("Thanh Toán"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: ListView(
      //   padding: const EdgeInsets.all(25.0),
      //   children :[ user.isNotEmpty
      //     ? PaddingCart()
      //     : const Center(child: Text('Không có sản phẩm trong giỏ hàng'))
      //   ]

      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            
            // Heading
            const Text(
              'Giỏ hàng',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 30),
              
            ),

            Expanded(
              child: SizedBox(
                  height: 144.0, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: lst_cat.length,
                    itemBuilder: (context, index) {
                      try{
                        if(user[widget.userToken]['cats'][index]['status'])
                        {
                          return CartItem(
                            path: user[widget.userToken]['cats'][index]['path']??'',
                            name: user[widget.userToken]['cats'][index]['name']??'',
                            price: user[widget.userToken]['cats'][index]['price']??'',
                            origin: user[widget.userToken]['cats'][index]['origin']??'',
                            quantity: user[widget.userToken]['cats'][index]['quantity'],
                            status: user[widget.userToken]['cats'][index]['status'],
                            userToken: 0,
                            idx: user[widget.userToken]['cats'][index]['cat_token'],
                          );

                        }
                        else
                        { 
                          return SizedBox();
                        }
                      }
                      catch(e)
                      {
                        print(e.toString());
                      }
                    },
                  ),
                ),
            ),

            GestureDetector(
              onTap: payNow,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(87, 175, 115, 1),
                  borderRadius: BorderRadius.circular(12)
                ),
                child: const Center(
                  child: Text(
                    "Thanh Toán",
                    style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const BotNav(idx: 1),
    );
  }
}