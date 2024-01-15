import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final int idx;
  final int quantity;
  final bool status;
  const OrderDetail({super.key, required this.idx, required this.quantity, required this.status});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
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
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((key,value) {
          user.add(value);
        });
        int count = user[2]['orders'].length;
        for(int i=0;i<count;i++){
          lst_order.add(user[2]['orders']);
        }
        print(user.length);
        print(lst_order.length);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin đơn hàng', style: TextStyle(color: Colors.black),),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: lst_order.length,
                    itemBuilder: (context,index){

                    }
                  ),
                )
              ]
            )
          )
        ],
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color.fromRGBO(87, 175, 115, 1),
            ),
            child: Visibility(
              child: TextButton(
                onPressed: (){}, 
                child: Text(
                  widget.status?'Hủy đơn hàng':'Mua lại', 
                  style: const TextStyle(
                    color: Colors.white ,
                    fontSize: 28
                  ),
                )
              ),
            ),
          ),
          Spacer()
        ],
    ),
    bottomNavigationBar: Row(
      children: [
        SizedBox(height: 50,)
      ],
    ),

    );
  }
}