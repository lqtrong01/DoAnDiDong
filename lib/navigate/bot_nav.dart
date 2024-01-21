import 'package:app_thuong_mai/screen/cart_screen.dart';
import 'package:app_thuong_mai/screen/home_screen.dart';
import 'package:app_thuong_mai/screen/notification_screen.dart';
import 'package:app_thuong_mai/screen/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class BotNav extends StatefulWidget {
  const BotNav({super.key, required this.idx});
  final int idx;
  @override
  State<BotNav> createState() => _BotNavState();
}

class _BotNavState extends State<BotNav> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  late int uid;
  final List<Map<dynamic, dynamic>> users = [];
  final Map<dynamic?, dynamic?> infoUser = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          users.add(value);
        });
        print(users);
        for(int i = 0; i<users.length;i++){
          if(users[i]['detail']['email']==user?.email.toString().toLowerCase()){
            infoUser.addAll(users[i]['detail']);
          }
        }
        print(infoUser);
        print(infoUser['token']);
        setState(() {
          uid = infoUser['token'];
        }); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    User? user = args?['user'];
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(26, 255, 255, 255),
      fixedColor: Colors.green[500],
      items: const [
        BottomNavigationBarItem(
          label: 'Trang chủ', icon: Icon(Icons.home_outlined,)
        ),
        BottomNavigationBarItem(
          label: 'Giỏ hàng', icon: Icon(Icons.shopping_cart_outlined)
        ),
        BottomNavigationBarItem(
          label: 'Thông báo', icon: Icon(Icons.notifications_none_outlined)
        ),
        BottomNavigationBarItem(
          label: 'Cá nhân', icon: Icon(Icons.account_circle_outlined),
        ),
      ],
      selectedIconTheme: IconThemeData(color: Colors.green[500]),
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      currentIndex: widget.idx,
      enableFeedback: false,
      onTap: (int indexOfItem) {
        if (indexOfItem == 0 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem){
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userToken: uid,)));
          }
        } else if (indexOfItem == 1 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(userToken: uid,)));
          }
        } else if (indexOfItem == 2 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen(userToken: uid,)));
          }
        } else if (indexOfItem == 3 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userToken: uid,)));
          }
        }
      },
    );
  }
}
