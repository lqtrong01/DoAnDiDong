import 'dart:html';

import 'package:app_thuong_mai/main.dart';
import 'package:app_thuong_mai/thanhtoan/order_name.dart';
import 'package:app_thuong_mai/thanhtoan/order_pay_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  final int userToken;
  const CartScreen({super.key, required this.userToken});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
        String dropdownValue = 'Thanh toán khi nhận hàng';
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  List<Map<dynamic, dynamic>> user = [];
  List<dynamic> lst_cat = [];
  Map<dynamic, dynamic> lst_name = {};
  List<dynamic> lst_order = [];

  bool isVisible=false;
  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchDataname();
    _loadOrderCount();
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
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  Future<void> _fetchDataname() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user.add(value);
        });
        for(int i = 0 ; i <user[widget.userToken]['cats'].length;i++){
          if(user[widget.userToken]['cats'][i]['status']==true)
            lst_order.add(user[widget.userToken]['cats'][i]);
        }
        print(lst_order);
          lst_name.addAll(user[widget.userToken]['detail']);
        print(lst_name);
        setState(() {});
      }
    } catch (error) {
      print("Lỗi name: $error");
    }
  }

  void tinhTien(){
    String thanhtien;
      

  }

  int orderNumber = 0;
  int notificationNumber = 0;
  Future<void> _loadOrderCount() async {
    try {
      DatabaseEvent event = await _databaseReference.child('users/${widget.userToken}').once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        Map fetchedUserNumber = dataSnapshot.value as Map;
        setState(() {
          orderNumber = fetchedUserNumber['orderCount'];
          notificationNumber = fetchedUserNumber['notificationCount'];
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  Future<void> addNotication() async {
    try{
      await _databaseReference.child('users/${0}').child('notifications/${notificationNumber}').set({
        'status': true,
        'title': 'Bạn vừa đặt thành công 1 đơn hàng'
      });
        notificationNumber++;
      await _databaseReference.child('users/${0}').update({
        'notificationCount': notificationNumber,
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> setCategory() async {
    try{
      for(int i = 0 ; i<lst_cat.length;i++){
        await _databaseReference.child('users/${0}').child('cats/${lst_cat[i]['cat_token']}').update({
          'status': false,
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> addNewOrder() async {
    try {
      for(int i = 0; i<lst_order.length;i++){
        await _databaseReference.child('users/${0}').child('orders/${orderNumber}').child('${i}').set({
          'name': lst_order[i]['name'],
          'origin': lst_order[i]['origin'],
          'path': lst_order[i]['path'],
          'price': lst_order[i]['price'],
          'quantity': lst_order[i]['quantity']
        });
      }
      orderNumber++;
      await _databaseReference.child('users/${0}').update({
        'orderCount': orderNumber,
      });
      
    } catch (error) {
      print(error.toString());
    }
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
                addNewOrder();
                setCategory();
                addNotication();
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
              },
              child: Text("Thanh Toán"),
            ),
          ],
        );
      },
    );
  }
  double calculateTotalAmount() {
    double totalAmount = 0;

    for (int index = 0; index < lst_cat.length; index++) {
      if (user[widget.userToken]['cats'][index]['status']) {
        // Lấy giá trị price từ chuỗi và chuyển đổi sang double
        double priceValue = double.parse(user[widget.userToken]['cats'][index]['price'].replaceAll(',', ''));

        // Lấy giá trị quantity từ dữ liệu
        int quantity = user[widget.userToken]['cats'][index]['quantity'];

        // Tính tổng tiền cho mỗi sản phẩm và cộng vào tổng đơn hàng
        totalAmount += quantity * priceValue;
    
      }
    }

    return  totalAmount;
  }

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
        title: Text('Thanh toán đơn hàng', style: TextStyle(color: Colors.black),),
     ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin đơn hàng',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 20),
            ),
            Column(
              children: [
                 Row(
                   children: [
                     Text(
              'Địa chỉ nhận hàng',
              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15),
              ),
              IconButton(onPressed: () {
                
              }, icon: const Icon(Icons.edit_outlined),color: const Color.fromRGBO(96, 96, 96, 1)),
              IconButton(
                icon: const Icon(Icons.arrow_drop_down_outlined),
                color: const Color.fromRGBO(96, 96, 96, 1),
                onPressed: () {
                  setState(() {
                    isVisible=!isVisible;
                  });
                },
              ),
                   ],
                 ),
                 Visibility(visible: isVisible,
                  child: Container(
              child: SizedBox(
                  height: 144.0, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      try{
                        {
                          return ordername(
                            location: lst_name['location']??'',
                            name: lst_name['name']??'',
                            phone: lst_name['phone']??'',
                            idx: lst_name['token'],
                          );
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
            )   
              ],
            ),
            Expanded(
              child: SizedBox(
                  height: 50.0, 
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: lst_cat.length,
                    itemBuilder: (context, index) {
                      try{
                        if(user[widget.userToken]['cats'][index]['status'])
                        {
                          return OrderPayItem(
                            path: user[widget.userToken]['cats'][index]['path']??'',
                            name: user[widget.userToken]['cats'][index]['name']??'',
                            price: user[widget.userToken]['cats'][index]['price']??'',
                            origin: user[widget.userToken]['cats'][index]['origin']??'',
                            quantity: user[widget.userToken]['cats'][index]['quantity'],
                            status: user[widget.userToken]['cats'][index]['status'],
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
Row(
      children: [ 
        Container(
          padding: const EdgeInsets.only(right: 90.0),
          child: Row(children: const [
                 Icon(Icons.attach_money,color: Colors.black),
                 Text(" Phương thức thanh toán")
              ],
            ),
        ),
        Column(mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             
              DropdownButton<String>(
                value: dropdownValue,
                items: <String>['Thanh toán khi nhận hàng', 'Thanh toán ATM'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      dropdownValue = newValue;
                        
                    });
                  }
                },
              )
            ],
        ),
      ],
    ),
Column(
      children: [
        Row(
            children: [
               Container(padding: const EdgeInsets.only(bottom: 15.0),
                child: Icon(size: 33,
                  Icons.calendar_today_outlined,color: Color.fromRGBO(244, 166, 13, 1),)),
               Container(padding: const EdgeInsets.only(bottom: 20.0),
                child: const Text(" Chi tiết hóa đơn", style: TextStyle(fontWeight: FontWeight.w300,fontSize: 20.0),))
            ],
          ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text("Tổng tiền cần thanh toán"),
          Text("${calculateTotalAmount().toStringAsFixed(2)} VND"),
        ],)
      ],
    ),
            Container(
              padding: const EdgeInsets.all(8.0),
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: payNow,
                child: Container(
                  width: MediaQuery.of(context).size.width/2,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(87, 175, 115, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: const [
                     Text(
                      "Thanh Toán",
                      style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1), fontSize: 20),
                    ),
                    SizedBox(width: 10.0,),
                    Icon(Icons.check,color: Colors.white,)
                  ],
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