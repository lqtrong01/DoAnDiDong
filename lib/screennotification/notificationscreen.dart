import 'package:app_thuong_mai/main.dart';
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
  var so=0;
    void editUser() async {
    try {
        await _databaseReference.child('users/${0}').child('notifications/${so++}').update({
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
    ThongbaoMua(userToken: 0);
  }
  
  @override
Widget build(BuildContext context) {
  // Kiểm tra xem tất cả các thông báo có trạng thái là false không
  bool allNotificationsFalse = user_cat.isNotEmpty &&
    user_cat[widget.userToken]['notifications'].every((notification) => notification['status'] == false);

  return Scaffold(
    appBar: AppBar(
      title: Text('Thông báo', style: TextStyle(color: Colors.black)),
    ),
    body: allNotificationsFalse
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(Icons.notifications, size: 50, color: Colors.yellow),
              SizedBox(height: 30,),
              Text('Không có thông báo', style: TextStyle(color: Colors.green, fontSize: 20)),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {

                   Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Text('Quay về Trang Chủ'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        )
      : ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          itemCount: lst_notification.length,
          itemBuilder: (context, index) {
            final item = lst_notification[index];
            if (user_cat[widget.userToken]['notifications'][index]['status'] == true) {
              titleOrder = '${user_cat[widget.userToken]['notifications'][index]['title']} ${user_cat[widget.userToken]['orders'][index]['name']}';
              return Dismissible(
                key: Key(item.toString()),
                onDismissed: (direction) {
                  setState(() {
                    lst_notification.removeAt(index);
                    editUser(); // Gọi phương thức update
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đơn hàng đã được xóa')),
                  );
                },
                background: Container(color: Colors.red),
                child: NotificationItem(title: titleOrder),
              );
            } else {
              return Container(); // Không hiển thị thông báo có trạng thái false
            }
          },
        ),
  );
}

  }
