import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:app_thuong_mai/screennotification/notification_item.dart';

class ThongbaoMua extends StatefulWidget {
  const ThongbaoMua({super.key});

  @override
  State<ThongbaoMua> createState() => _ThongbaoMuaState();
}

class _ThongbaoMuaState extends State<ThongbaoMua> {

final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();
  int notiCount=0;
  List<Map<dynamic, dynamic>> user_cat = [];
  List<Map<dynamic, dynamic>> lst_notification = [];
  // final notifications = [
  //   'Bạn vừa thanh toán thành công một đơn hàng',
  //   'Bạn vừa hủy thành công một đơn hàng',
  //   'Bạn vừa hủy thành công một đơn hàng',
  //   'Bạn vừa thanh toán thành công một đơn hàng',
  //   'Bạn vừa thanh toán thành công một đơn hàng',
  // ];
  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((key, value) {
          user_cat.add(value);
        });

        for(int i = 0; i<user_cat[0]['notifications'].length;i++){
          lst_notification.add(user_cat[0]['notifications']);
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
  void initState() {
    _fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo', style: TextStyle(color: Colors.black),),
      ),
      body:lst_notification.isEmpty?
      Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(Icons.notifications, size: 50, color: Colors.yellow),
              SizedBox(height: 30,),
              Text('Không có thông báo', style: TextStyle(color: Colors.green, fontSize: 20)),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {},
                child: Text('Quay về Trang Chủ'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        ):
       ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: lst_notification.length,
          itemBuilder: (context, index){
           // print(lst_notification[index]);
            if(user_cat[0]['orders']['order0']['status']==true)
              titleOrder = '${user_cat[0]['notifications']['notifi${index}']} ${user_cat[0]['orders']['order${index}']['name']}';
            else if(user_cat[0]['orders']['order0']['status']==false)
              titleOrder = 'Bạn đã hủy đơn hàng';
            else titleOrder = 'Giao hàng không thành công';

            return NotificationItem(title: titleOrder);
          }
        ),
    );
  }
    // Scaffold(
    //   appBar: AppBar(
    //     title: Text('Thông báo'),
    //   ),
    //   body: lst_notification.isEmpty?ListView.builder(
    //           itemCount: lst_notification.length,
    //           itemBuilder: (context, index) {
    //             return Dismissible(
    //               key: Key(lst_notification[index]['']),
    //               onDismissed: (direction) {
    //                 setState(() {
    //                   lst_notification.removeAt(index);
    //                 });
    //                 ScaffoldMessenger.of(context).showSnackBar(
    //                   SnackBar(content: Text('$lst_notification xóa')),
    //                 );
    //               },
    //               background: Container(color: Colors.red),
    //               child: ListTile(
    //                 leading: Icon(Icons.notifications, color: Colors.amber),
    //                 title: Text(lst_notification[index]['no${index}']),
    //               ),
    //             );
    //           },
    //         ):
    //       Center(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children:[
    //           Icon(Icons.notifications, size: 50, color: Colors.yellow),
    //           SizedBox(height: 30,),
    //           Text('Không có thông báo', style: TextStyle(color: Colors.green, fontSize: 20)),
    //           SizedBox(height: 10,),
    //           ElevatedButton(
    //             onPressed: () {},
    //             child: Text('Quay về Trang Chủ'),
    //             style: ElevatedButton.styleFrom(primary: Colors.green),
    //           ),
    //         ],
    //       ),
    //     ),
          
    //   bottomNavigationBar: BottomNavigationBar(
    //     backgroundColor: Colors.amber,
    //     items: <BottomNavigationBarItem>[
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.home, color: Colors.blue), label: 'Home'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.shopping_cart, color: Colors.blue), label: 'Cart'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.notifications, color: Colors.blue),
    //           label: 'Thông báo'),
    //       BottomNavigationBarItem(
    //           icon: Icon(Icons.person, color: Colors.blue), label: 'Tôi'),
    //     ],
    //   ),
    // );
  
}