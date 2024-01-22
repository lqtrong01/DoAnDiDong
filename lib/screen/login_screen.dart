
import 'package:animate_do/animate_do.dart';
import 'package:app_thuong_mai/navigate/bot_nav.dart';
import 'package:app_thuong_mai/screen/forgot_password.dart';
import 'package:app_thuong_mai/screen/home_screen.dart';
import 'package:app_thuong_mai/screen/loading_screen.dart';
import 'package:app_thuong_mai/user_auth/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  late String email;
  late String passWord;
  int userToken = 0;

  int userCount = 0;
  bool isCheckedVisiblePassword = true;
  bool isChecked = true;
  bool isLoading = false;
  bool isClosing = false;

  List<Map<dynamic, dynamic>> users = [];
  final Map<dynamic?, dynamic?> infoUser = {};
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

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
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<void> _loadSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool('saveUser') ?? false;
      if (isChecked) {
        txt_email.text = prefs.getString('savedEmail') ?? '';
        txt_password.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveUser', isChecked);
    if (isChecked) {
      prefs.setString('savedEmail', txt_email.text);
      prefs.setString('savedPassword', txt_password.text);
    }
  }

  Future<void> _resetsaveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('savedEmail');
    prefs.remove('savedPassword');
    prefs.remove('saveUser');
  }

  void autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('savedEmail')??null;
    String? savedPassword = prefs.getString('savedPassword')??null;

    if (savedEmail != null && savedPassword != null) {
      // Thực hiện đăng nhập tự động
      signInWithEmailAndPassword(savedEmail, savedPassword)
          .then((userCredential) {
        if (userCredential != null) {
          if (users != null) {
            for (int i = 0; i < users.length; i++) {
              if (users[i]['email'] == savedEmail) {
                userToken = users[i]['token'];
                print(userToken);
              }
            }
          }
          // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đăng nhập ở đây
          showSnackbar("Đăng nhập thành công: ${userCredential.user?.email}");
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushNamed(context, '/logout');
        }
      });
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return null;
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }

  Future<void> _loadUserCount() async {
    try {
      DatabaseEvent event = await _databaseReference.child('userCount').once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        int fetchedUserNumber = dataSnapshot.value as int;
        setState(() {
          userCount = fetchedUserNumber;
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  Future<bool> _isExistingUser(String email) async {
  try {
    // Lấy dữ liệu từ Firebase Realtime Database
    DatabaseEvent event = await _databaseReference.child('users').orderByChild('detail/email').equalTo(email).once();
    DataSnapshot? dataSnapshot = event.snapshot;

    // Kiểm tra sự tồn tại của dữ liệu
    return dataSnapshot != null && dataSnapshot.value != null;
  } catch (e) {
    print("Error checking existing user: $e");
    return false;
  }
}

  /* Future<void> _createEmailPasswordAccount(String email, String password)async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
    }catch(e){
      print("Error creating email/password account: $e");
    }
  } */

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      /* final User? firebaseUser=userCredential.user; */
      if(userCredential.user != null){
        bool isExisting = await _isExistingUser(userCredential.user!.email!);
        if(!isExisting){
            try{
              String userId = userCredential.user!.uid;
              String name = userCredential.user!.displayName??"";
              String avatar = userCredential.user!.photoURL??"";
              String phone = userCredential.user!.phoneNumber??"";
              String _email = userCredential.user!.email??"";

              await _databaseReference.child('users').child('$userCount').set({
                'categoryCount': 0,
                'orderCount': 0,
                'notificationCount':0,
                'favouriteCount':0,
              });

              await _databaseReference.child('users').child('$userCount').child('detail').set({
                'avatar': avatar,
                'name': name,
                'phone': phone,
                'email': _email,
                'location':"",
                'password': "defaultPassword",
                'token': userCount,
                'userID': userId,
              });
              showSnackbar('Tạo tài khoản bằng Google thành công');
              userCount++;
              await _databaseReference.update({'userCount': userCount,});
            } catch(e){
              showSnackbar('Tạo tài khoản bằng Google thất bại');
            }
        }
        }
        return userCredential;
    } catch (error) {
      print("Google sign in error: $error");
      return null;
    }
  }

  void _showForgotPasswordBottomSheet() {
      showModalBottomSheet(
        context: context, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.vertical(top: Radius.circular(50))),
        builder: (BuildContext context) {
          return ForgotPassword(); 
        },
      );
}

  @override
  void initState() {
    _loadSavedUser();
    _loadUserCount();
    _fetchData();
    /* isChecked?autoLogin():null; */
    isCheckedVisiblePassword=true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) => isLoading
    ? LoadingScreen() : _LoginScreen();

  Widget _LoginScreen(){
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          Stack(children: [
            FadeInDown(duration: const Duration(seconds: 1),
              child: Container(child: Image.asset('assets/img/dangnhap.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/2-90,)),),
            Positioned(
              left: 135.0,
              top: 220.0,
              child: FadeInUp(delay: const Duration(milliseconds: 100), duration: const Duration(seconds: 1),
                child: const Text("LOGIN", style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w600, color: Colors.white))),),
          ],),
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInLeft(delay: const Duration(milliseconds: 100),duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 15.0),
                    child: const Text("Get your groceries with Vephenomsoft",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 32.0),)),),
                FadeInDown(delay: const Duration(milliseconds: 200),duration: const Duration(seconds: 1),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextField(
                      controller: txt_email,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Email",
                      ),
                    ),
                  ),
                ),
                FadeInDown(delay: const Duration(milliseconds: 300),duration: const Duration(seconds: 1),
                  child: Container(
                    child: TextField(
                      obscureText: isCheckedVisiblePassword,
                      controller: txt_password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Password",
                        suffixIcon: IconButton(onPressed: () {
                          setState(() {
                            isCheckedVisiblePassword=!isCheckedVisiblePassword;
                          });
                        }, icon: isCheckedVisiblePassword?Icon(Icons.visibility_off):Icon(Icons.visibility)),
                      ),
                    ),
                  ),
                ),
                FadeInLeft(delay: const Duration(milliseconds: 400),duration: const Duration(seconds: 1),
                  child: Row(children: [
                          Checkbox(value: isChecked, onChanged: (value) {
                            setState(() {
                              isChecked=value!;
                            });
                          },
                        ),
                          Text("Lưu đăng nhặp",style: TextStyle(fontSize: 18.0),),
                        ],
                      ),
                    ),
                FadeInUp(delay: const Duration(milliseconds: 500),duration: const Duration(seconds: 1),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Expanded(child:
                    ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),
                    onPressed: () {
                      setState(() {
                        email = txt_email.text;
                        passWord = txt_password.text;
                        signInWithEmailAndPassword(email, passWord).then((userCredential) {
                        if (userCredential != null) {
                          if(users!=null){
                            for(int i=0;i<users.length;i++){
                              if(users[i]['detail']['email']==email){
                                userToken=users[i]['detail']['token'];
                                print(userToken);
                              }
                            }
                            // try {
                            //   User? user = userCredential.user;
                            //   if (user != null) {
                            //     Provider.of<UserProvider>(context, listen: false).setUser(user);
                            //   } else {
                            //     print("Some error occurred");
                            //   }
                            // } catch (e) {
                            //   print("Error during sign in: $e");
                            // }
                          }
                          // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đăng nhập ở đây
                          showSnackbar("Đăng nhập thành công: ${userCredential.user?.email}");
                          isChecked?_saveUser():_resetsaveUser();
                          Navigator.popUntil(context, (route) => route.isFirst);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userToken: userToken,),));
                        } else {
                          // Xử lý lỗi đăng nhập
                          showSnackbar("Đăng nhập thất bại");
                        }
                      });
                    });
                  }, child: const Text("Đăng Nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)))
                  )
                ],),),
                FadeInLeft(delay: const Duration(milliseconds: 600),duration: const Duration(seconds: 1),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: const Text("Hoặc",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18.0),)),),
                FadeInUp(delay: const Duration(milliseconds: 700),
                  duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 20.0),
                    child: _googleSignInButton(),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [ 
                  FadeInLeft(delay: const Duration(milliseconds: 800), duration: const Duration(seconds: 1),
                    child: Container(child: const Text("Chưa có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0))),),
                  FadeInRight(delay: const Duration(milliseconds: 900), duration: const Duration(seconds: 1),
                    child: TextButton(onPressed: () async {
                      setState(() {
                        isLoading=true;
                      });
                      await Future.delayed(const Duration(seconds: 3));
                      setState(() {
                        isLoading=false;
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(context, '/register');
                      });
                  }, child: const Text("Đăng ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 1))),)),
                ],
                )
              ],
            ),
          )
        ],
      ),));
  }

  Widget _googleSignInButton(){
    return Center(child: SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.google,
        text: "Tiếp tục với Google",
        onPressed: () async {
          UserCredential? userCredential = await _signInWithGoogle();
          if(userCredential!=null){
            setState(() {
              if(users!=null){
                for(int i=0;i<users.length;i++){
                  if(users[i]['detail']['email']==userCredential.user!.email){
                    userToken=users[i]['detail']['token'];
                    print(userToken);
                  }
                }
                // try {
                //   User? user = userCredential.user;
                //   if (user != null) {
                //     Provider.of<UserProvider>(context, listen: false).setUser(user);
                //   } else {
                //     print("Some error occurred");
                //   }
                // } catch (e) {
                //   print("Error during sign in: $e");
                // }
              }
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(userToken: userToken)));
            });
            showSnackbar("Đăng nhập thành công: ${userCredential.user?.email}");
          }else{
            showSnackbar("Đăng nhập bằng Google thất bại");
          }
      }),
    ),);
  }
}