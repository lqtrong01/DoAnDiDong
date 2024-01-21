import 'package:app_thuong_mai/Item/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderItem extends StatefulWidget {
  final Text title;
  final String path;
  final String name;
  final String price;
  final String origin;
  final int quantity;
  final int idx;
  final int userToken;
  const OrderItem({
    super.key, 
    required this.title, 
    required this.path, 
    required this.name, 
    required this.price, 
    required this.origin,
    required this.quantity,
    required this.idx,
    required this.userToken,
  });

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
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
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0,),
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 20,),
                widget.title,
              ],
            ),
          ),
          Divider(thickness: 2,),
          ListTile(
            leading: Image.network(widget.path, width: 60, height: 60, fit: BoxFit.contain,),
            title: Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(widget.origin),
            trailing: Text('x'+widget.quantity.toString()+'\n'+widget.price),
            onTap: (){
              try{
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetail(idx: widget.idx, status: true, userToken: widget.userToken,)));
              }catch(e){
                print(e.toString());
              }
            },
          )
        ],
      ),
    );
  }
}