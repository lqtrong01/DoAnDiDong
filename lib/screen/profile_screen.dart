import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:app_thuong_mai/user_auth/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  String userName = '';

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
            .orderByChild('email')
            .equalTo(user.email)
            .once();
        DataSnapshot? dataSnapshot = event.snapshot;

        if (dataSnapshot != null && dataSnapshot.value != null) {
          Map<dynamic, dynamic> userData =
              (dataSnapshot.value as Map).values.first;

          String fetchedUserName = userData['username'];
          setState(() {
            userName = fetchedUserName;
          });
        }
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: 12.0,),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('Hình'),
                  ),
                  SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12,),
                      Text(
                        userName.isNotEmpty ? userName : 'Loading...',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tài khoản : ',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.mode_edit_outlined),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)
                  ),
                  child: ListTile(
                    onTap: () {
                      
                    },
                    leading: Icon(Icons.shopping_bag_outlined),
                    title: Text('Đơn hàng'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)
                  ),
                  child: ListTile(
                    onTap: (){},
                    leading: Image(image: AssetImage('assets/icons/icons8-heart-24.png')),
                    title: Text('Yêu thích'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)
                  ),
                  child: ListTile(
                    onTap: (){},
                    leading: Icon(Icons.insert_chart_outlined_outlined),
                    title: Text('Thống kê'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)
                  ),
                  child: ListTile(
                    onTap: (){},
                    leading: Icon(Icons.help_outline_outlined),
                    title: Text('Help'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)
                  ),
                  child: ListTile(
                    onLongPress: (){
                      
                    },
                    onTap: (){},
                    leading: Icon(Icons.help),
                    title: Text('About'),
                    trailing: Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),

              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ListTile(
                    leading: Icon(Icons.logout_outlined),
                    title: Text('Đăng Xuất'),
                    trailing: null,
                    textColor: Colors.green[500],
                    iconColor: Colors.green[500],
                    onTap: (){},
                  )
                ],
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar: const BotNav(idx: 3),
    );
  }
}
