// import 'package:charts_flutter/flutter.dart' as charts;

// class StatisticsItem {
//   String year;
//   String month;
//   int financial;
//   final charts.Color color;

//   StatisticsItem({
//     required this.year, 
//     required this.month, 
//     required this.financial, 
//     required this.color
//   });
// }

import 'dart:html';
import 'package:app_thuong_mai/Item/statistics_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatisticsItem extends StatefulWidget {
  final int userToken;

  const StatisticsItem({
    super.key,
    required this.userToken
  });

  @override
  State<StatisticsItem> createState() => _StatisticsItemState();
}

class _StatisticsItemState extends State<StatisticsItem> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  //Danh sách người dùng
  List<Map<dynamic, dynamic>> user = [];

  //Danh sách giỏ hàng
  List<dynamic> lst_orders = [];

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
        for(var value in user[widget.userToken]['orders']){
          lst_orders.add(value);
        }
        print(lst_orders);
        print(lst_orders.length);
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  late String date;
  int TachChuoi(String date, String type){
    DateTime dateTime = DateTime.parse(date+'z');
    print(dateTime);
    print('tháng'+dateTime.month.toString());
    print('năm'+dateTime.year.toString());
    if(type=='month'){
      return dateTime.month;
    }
    else if(type=='year'){
      return dateTime.year;
    }
    else return 0;
  }
  int month = 0;
  int year = 0;
  @override
  Widget build(BuildContext context) {
    try{
      date = user[widget.userToken]['orders'][0][0]['ddmmyy'];
      month = TachChuoi(date, 'month');
      year = TachChuoi(date, 'year');
      print(month+year);
    }
    catch(e)
    {
      print(e.toString());
    }
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
        title: Text('Thống kê', style: TextStyle(color: Colors.black),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
        ],
      )
    );
  }
}