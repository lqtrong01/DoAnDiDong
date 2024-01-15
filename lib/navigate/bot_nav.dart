import 'package:app_thuong_mai/screen/home_screen.dart';
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
  final List<dynamic> infoUser = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {

        DatabaseEvent event = await _databaseReference
            .child('users')
            .orderByChild('detail/email')
            .equalTo('abc@gmail.com')
            .once();
        DataSnapshot? dataSnapshot = event.snapshot;
        
        if (dataSnapshot != null && dataSnapshot.value != null) {
          // Extract user data from the dataSnapshot
          List<dynamic> userDataMap = dataSnapshot.value as List;
          userDataMap.forEach((value){
            infoUser.add(value);
          });
          print(infoUser);
          setState(() {
            uid = infoUser[0]['detail']['token'];
          });
        } else {
          // Handle the case where no data is found
          print("No data found for user with email: ${user.email}");
        }
      }
    } catch (error) {
      // Handle errors during the data fetching process
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
        )
      ],
      selectedIconTheme: IconThemeData(color: Colors.green[500]),
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      currentIndex: widget.idx,
      onTap: (int indexOfItem) {
        if (indexOfItem == 0 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem)
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userToken: uid,)));
        } else if (indexOfItem == 1 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem)
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userToken: uid,)));
        } else if (indexOfItem == 2 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userToken: uid,)));
          }
        } else if (indexOfItem == 3 && indexOfItem != widget.idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (widget.idx != indexOfItem) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userToken: uid,)));
          }
        }
      },
    );
  }
}
