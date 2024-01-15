import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:app_thuong_mai/screen/edit_profile_screen.dart';
import 'package:app_thuong_mai/screen/favourite_screen.dart';
import 'package:app_thuong_mai/screen/login_screen.dart';
import 'package:app_thuong_mai/screen/order_screen.dart';
import 'package:app_thuong_mai/user_auth/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final int userToken;
  const ProfileScreen({Key? key, required this.userToken});
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
  String email = '';
  int? uid;
  String image_url = '';
  final List<dynamic> infoUser = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Get the current authenticated user
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Use orderByChild and equalTo to fetch user data based on email
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
            userName = infoUser[0]['detail']['name']??'';
            image_url = infoUser[0]['detail']['path']??'';
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 12.0,),
              const Divider(thickness: 2,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(width: 12.0,),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('hình'),
                    child: Image.network(image_url, width: double.infinity, height: double.infinity,),
                  ),
                  const SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12,),
                      Text(
                        userName.isNotEmpty ? userName : 'Loading...',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Tài khoản : '+uid.toString(),
                        softWrap: true,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context)=> EditProfileScreen(userToken: uid!,)));
                        },
                        icon: const Icon(Icons.mode_edit_outlined),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 2,),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromRGBO(196, 198, 198, 1))
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(userToken: uid!),));
                    },
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text('Đơn hàng'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromRGBO(196, 198, 198, 1))
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FavouriteScreen(userToken: uid!,)));
                    },
                    leading: const Image(image: AssetImage('assets/icons/icons8-heart-24.png'), color: Color.fromRGBO(196, 198, 198, 1),),
                    title: const Text('Yêu thích'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromRGBO(196, 198, 198, 1))
                  ),
                  child: ListTile(
                    onTap: (){},
                    leading: const Icon(Icons.insert_chart_outlined_outlined),
                    title: const Text('Thống kê'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromRGBO(196, 198, 198, 1))
                  ),
                  child: ListTile(
                    onTap: (){},
                    leading: const Icon(Icons.help_outline_outlined),
                    title: const Text('Help'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: const Color.fromRGBO(196, 198, 198, 1))
                  ),
                  child: ListTile(
                    onTap: (){
                      
                    },
                    leading: const Icon(Icons.help),
                    title: const Text('About'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.5, color: const Color.fromRGBO(196, 198, 198, 1) ,)
        ),
        margin: const EdgeInsets.all(16.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Đăng Xuất'),
              trailing: null,
              textColor: const Color.fromRGBO(87, 175, 115, 1),
              iconColor: const Color.fromRGBO(87, 175, 115, 1),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BotNav(idx: 3),
    );
  }
}


