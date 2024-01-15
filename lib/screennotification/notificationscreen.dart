import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:app_thuong_mai/screennotification/notification_item.dart';

class ThongbaoMua extends StatefulWidget {
  final int userToken;
  const ThongbaoMua({super.key,required this.userToken});

  @override
  State<ThongbaoMua> createState() => _ThongbaoMuaState();
}

class _ThongbaoMuaState extends State<ThongbaoMua> {
  TextEditingController status = TextEditingController();

final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();
  int notiCount=0;
  List<Map<dynamic,dynamic>> user_cat = [];
  List<dynamic> lst_notification = [];

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user_cat.add(value);
        });
        try{
          for (var value in user_cat[widget.userToken]['notifications']) {
            lst_notification.add(value);
          }
        }catch(e){
          print('error'+e.toString());
        }
        // print(user.length);
        // print(lst_order);
        // print(lst_order.length);
        setState(() {
          
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
    void editUser() async {
    try {
        await _databaseReference.child('users/${0}').child('notifications/${0}').update({
          'status': false,
        });
      
    } catch (error) {
      print(error.toString());
    }
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
      body:
ListView.builder(
  physics: AlwaysScrollableScrollPhysics(),
  itemCount: lst_notification.length,
  itemBuilder: (context, index) {
    final item = lst_notification[index];
     if (user_cat[widget.userToken]['notifications'][index]['status'] == true) 
       titleOrder = '${user_cat[widget.userToken]['notifications'][index]['title']} ${user_cat[widget.userToken]['orders'][index]['name']}';
//       return NotificationItem(title: titleOrder);
    return Dismissible(
      key: Key(item.toString()),
      onDismissed: (direction) {
        // Xóa mục khỏi danh sách
        setState(() {
          lst_notification.removeAt(index);
          editUser();
        });
        // Thay đổi trạng thái đơn hàng thành false
        user_cat[widget.userToken]['orders'][index]['status'] = false;

        // Hiển thị một snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đơn hàng đã được xóa')),
        );
        
      },
      background: Container(color: Colors.red),
      child: NotificationItem(title: titleOrder),
    );
  },
),

    );
  }
}