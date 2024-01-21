import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:app_thuong_mai/screen/edit_profile_screen.dart';
import 'package:app_thuong_mai/screen/favourite_screen.dart';
import 'package:app_thuong_mai/screen/loading_screen.dart';
import 'package:app_thuong_mai/screen/login_screen.dart';
import 'package:app_thuong_mai/screen/order_screen.dart';
import 'package:app_thuong_mai/screen/statistics_screen.dart';
import 'package:app_thuong_mai/user_auth/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final List<Map<dynamic,dynamic>> infoUser = [];

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
          infoUser.add(value);
        });
        setState(() {
            uid = infoUser[widget.userToken]['detail']['token'];
            userName = infoUser[widget.userToken]['detail']['name']??'';
            image_url = infoUser[widget.userToken]['detail']['avatar']??'';

        }); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  final _googleSignIn = GoogleSignIn();
  bool isLoading = false;
  Future<void> _signOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedEmail', '');
    prefs.setString('savedPassword', '');
    prefs.remove('saveUser');
    print("Đăng xuất E/P thành công");
    print(prefs.getBool('saveUser'));
    print(prefs.getString('savedEmail'));
    print(prefs.getString('savedPassword'));
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _signOutUser();
      print("Đã đăng xuất thành công");
    } catch (error) {
      print("Lỗi đăng xuất: $error");
    }
  }

   void showDialogOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Xác nhận xóa sản phẩm ra khỏi giỏ hàng'),
          content: Text('Bạn có muốn đăng xuất sản phẩm hay không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  isLoading=true;
                  _handleSignOut();
                });
                await Future.delayed(const Duration(seconds: 2));
                setState(() async {
                  isLoading=false;
                  /* SharedPreferences pref = await SharedPreferences.getInstance();
                  await pref.remove('saveFirstUse'); */
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, '/logo');
                });
                (context as Element).reassemble();
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => isLoading
    ? LoadingScreen() : _LogoutScreen();
  Widget _LogoutScreen(){
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
                    radius: 60,
                    backgroundImage: NetworkImage(image_url),
                  ),
                  const SizedBox(width: 16,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12,),
                      Text(
                        userName.isNotEmpty ? userName : 'Loading...',
                        softWrap: true,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                    leading: const Image(image: AssetImage('assets/icons/icons8-heart-24.png'), color: Color.fromRGBO(96, 96, 96, 1),),
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: ((context) => StatisticsItem(userToken: widget.userToken,))));
                    },
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
              onTap: () async {
                showDialogOut(context);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BotNav(idx: 3),
    );
  }
}