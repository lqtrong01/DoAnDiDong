import 'package:app_thuong_mai/Item/order_detail_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class OrderDetail extends StatefulWidget {
  final int idx;
  final bool status;
  final int userToken;
  const OrderDetail({super.key, required this.idx, required this.status, required this.userToken});

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

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
        List<dynamic> data = (dataSnapshot.value as Map)['users'][widget.userToken]['orders'][widget.idx];
        data.forEach((value) {
          lst_order.add(value);
        });
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
  String name = '';
  String phone = '';
  String location = '';
  String total_price = '';
  @override
  Widget build(BuildContext context) {
    try{
      name = lst_order[0]['username'];
      phone = lst_order[0]['phone'];
      location = lst_order[0]['location'];
      total_price = lst_order[0]['total'].toString();
    }catch(e){
      print(e.toString());
    }
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
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0,),
                Container(
                  child: SizedBox(
                    height: 144.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Địa chỉ nhận hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        ListTile(
                          title:Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
                            Text('(+84) '+ phone, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
                            Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
                          ],
                          ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: lst_order.length,
                    itemBuilder: (context,index){
                      return OrderDetailItem(
                        path: lst_order[index]['path']??'', 
                        name: lst_order[index]['name']??'', 
                        origin: lst_order[index]['origin']??'', 
                        price: lst_order[index]['price']??'',
                        quantity: lst_order[index]['quantity'],
                        token: lst_order[index]['token']??0, 
                        userToken: widget.userToken
                      );
                    }
                  ),
                ),
                SizedBox(height: 30.0,),
                Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text("Tổng tiền",style: TextStyle(fontSize: 18, color: Colors.red),),
                      Text("${total_price} VND", style: TextStyle(fontSize: 18, color: Color.fromRGBO(28, 126, 56, 1)),),
                    ],)
                  ],
                ),
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
              visible: false,
              child: Expanded(
                child: ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),
                  onPressed: () {
                  }, 
                  child: Text(widget.status?'Hủy đơn hàng':'Mua lại',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)))
              )
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