import 'package:app_thuong_mai/Item/cart_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
    final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> products = [];
  List<Map<dynamic, dynamic>> displayProduct = [];
  List<Map<dynamic, dynamic>> waters = [];
  List<Map<dynamic, dynamic>> vegetables = [];
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
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['shop_cat'];

        data.forEach((key, value) {
          products.add(value);
        });
        for(int i = 0;i<products.length;i++){
          if(products[i]['type']=='water')
            waters.add(products[i]);
          else vegetables.add(products[i]);
        }
        setState(() {}); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  //thanh toán
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
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                // Gọi hàm thanh toán ở đây nếu cần
                // payNow();
                Navigator.of(context).pop(); // Đóng hộp thoại
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
      body: 
       Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            //heading
            Text(
              'Giỏ hàng',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 30),
              
            ),

            //list of cart items
            Expanded(
              child: SizedBox(
                  height: 144.0, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: vegetables.length,
                    itemBuilder: (context, index) {
                      if (index < vegetables.length) {
                        return CartItem(
                          path: vegetables[index]['path'],
                          name: vegetables[index]['pro_name'],
                          price: vegetables[index]['price'],
                          origin: vegetables[index]['origin'],
                          idx: vegetables[index]['token']??0,
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
            ),

            //pay button
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
    );
  }
}