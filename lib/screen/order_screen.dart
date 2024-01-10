
import 'package:app_thuong_mai/Item/item.dart';
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

  final List<Map<dynamic, dynamic>> user_cat = [];
  final List<Map<dynamic, dynamic>> lst_order = [];

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
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((key, value) {
          user_cat.add(value);
        });

        for(int i = 0; i<user_cat[widget.userToken]['orders'].length;i++){
          lst_order.add(user_cat[widget.userToken]['orders']);
        }
        
        print(user_cat); 
        setState(() {}); // Trigger a rebuild with the fetched data
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
          itemCount: lst_order.length,
          itemBuilder: (context, index){
            if(user_cat[widget.userToken]['orders']['order0']['status']==true)
              titleOrder = 'Bạn đã đặt thành công một ${user_cat[0]['orders']['order0']['name']}';
            else if(user_cat[widget.userToken]['orders']['order0']['status']==false)
              titleOrder = 'Bạn đã hủy đơn hàng';
            else titleOrder = 'Giao hàng không thành công';

            return OrderItem(
              title: Text(titleOrder, style: TextStyle(color: user_cat[0]['orders']['order${index}']['status']?Colors.green[500]:Colors.yellow,fontSize: 20),), 
              path: user_cat[widget.userToken]['orders']['order${index}']['path'], 
              name: user_cat[widget.userToken]['orders']['order${index}']['name'], 
              price: user_cat[widget.userToken]['orders']['order${index}']['price'], 
              origin: user_cat[widget.userToken]['orders']['order${index}']['origin'], 
              quantity: user_cat[widget.userToken]['orders']['order${index}']['quantity'], 
              idx: 0
            );
          }
        ),
    );
  }
}