import 'package:app_thuong_mai/Item/order_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  final int userToken;
  const OrderScreen({super.key, required this.userToken});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  final List<Map<dynamic, dynamic>> user = [];
  final List<dynamic> lst_order = [];

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
        try{
          for (var value in user[widget.userToken]['orders']) {
            lst_order.add(value);
          }
        }
        catch(e){
          print('error'+e.toString());
        }
        print(user.length);
        print(lst_order);
        print(lst_order.length);
        setState((){
          
        }); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  String titleOrder = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: Text('Đơn hàng', style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: lst_order.length,
          itemBuilder: (context, index){
            try{
                titleOrder = 'Bạn đã đặt thành công ${user[widget.userToken]['orders'][index].length} sản phẩm';
              return OrderItem(
                title: Text(titleOrder), 
                path: user[widget.userToken]['orders'][index][0]['path']??'', 
                name: user[widget.userToken]['orders'][index][0]['name']??'', 
                price: user[widget.userToken]['orders'][index][0]['price']??'', 
                origin: user[widget.userToken]['orders'][index][0]['origin']??'', 
                quantity: user[widget.userToken]['orders'][index][0]['quantity']??'',
                idx: index,
                userToken: widget.userToken,
              );
            }catch(e){
              print(e.toString());
            }
          }
        ),
    );
  }
}