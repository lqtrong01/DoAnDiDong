import 'package:app_thuong_mai/duytridangnhap.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  TextEditingController txt_username = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  late String userName;
  late String passWord;
  late int userToken;

  bool isCheckedVisiblePassword = true;
  bool isChecked = false;

  late List<Map<dynamic, dynamic>> users = [];
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  Future<void> _loadSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isChecked = prefs.getBool('saveUser') ?? false;
      if (isChecked) {
        txt_username.text = prefs.getString('savedUsername') ?? '';
        txt_password.text = prefs.getString('savedPassword') ?? '';
      }
    });
  }

  Future<void> _saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('saveUser', isChecked);
    if (isChecked) {
      prefs.setString('savedUsername', txt_username.text);
      prefs.setString('savedPassword', txt_password.text);
      Signing(isChecked: isChecked);
    }
  }

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        Map<dynamic, dynamic> data = (dataSnapshot.value as Map)['users'];

        data.forEach((key, value) {
          users.add(value);
        });
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
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

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (error) {
      print("Google sign in error: $error");
      return null;
    }
  }

  @override
  void initState() {
    _loadSavedUser();
    isCheckedVisiblePassword=true;
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          Container(child: Image.asset('assets/img/dangnhap.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height/2-90,)),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get your groceries with Vephenomsoft",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 32.0),),
                const SizedBox(height: 15.0,),
                TextField(
                  controller: txt_username,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                    labelText: "Email",
                    hintText: "Nhập vào email",
                  ),
                ),
                const SizedBox(height: 7.0,),
                TextField(
                  obscureText: isCheckedVisiblePassword,
                  controller: txt_password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                    labelText: "Password",
                    hintText: "Nhập vào password",
                    suffixIcon: IconButton(onPressed: () {
                      isCheckedVisiblePassword=!isCheckedVisiblePassword;
                      setState(() {
                        
                      });
                    }, icon: isCheckedVisiblePassword?Icon(Icons.password):Icon(Icons.remove_red_eye)),
                  ),
                ),
                Row(children: [
                  Checkbox(value: isChecked, onChanged: (value) {
                    setState(() {
                      isChecked=value!;
                      _saveUser();
                    });
                  },),
                  Text("Lưu đăng nhặp",style: TextStyle(fontSize: 18.0),),
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Expanded(child: 
                    ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),
                    onPressed: () {
                      setState(() {
                        userName = txt_username.text;
                        passWord = txt_password.text;
                        signInWithEmailAndPassword(userName, passWord).then((userCredential) {
                        if (userCredential != null) {
                          if(users!=null){
                            for(int i=0;i<users.length;i++){
                              if(users[i]['email']==userName){
                                userToken=users[i]['token'];
                                print(userToken);
                              }
                            }
                          }
                          // Đăng nhập thành công, bạn có thể thực hiện các hành động sau đăng nhập ở đây
                          showSnackbar("Đăng nhập thành công: ${userCredential.user?.email}");
                          Navigator.popUntil(context, (route) => route.isFirst);
                          /* Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),)), */
                        } else {
                          // Xử lý lỗi đăng nhập
                          showSnackbar("Đăng nhập thất bại");
                        }
                      });
                    });
                  }, child: const Text("Đăng Nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0))))
                ],),
                const Text("Hoặc",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18.0),),
                const SizedBox(height: 20.0,),
                _googleSignInButton(),
                const SizedBox(height: 20.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [ const
                  Text("Chưa có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                  TextButton(onPressed: () {
                    setState(() {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, '/register');
                    });
                  }, child: const Text("Đăng ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 1))),)
                ],)
              ],
            ),
          )
        ],
      ),),
    );
  }

  Widget _googleSignInButton(){
    return Center(child: SizedBox(
      height: 50,
      child: SignInButton(
        Buttons.google,
        text: "Tiếp tục với Google",
        onPressed: () async{
          UserCredential? userCredential = await _signInWithGoogle();
          if(userCredential!=null){
            setState(() {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, '/register');
            });
          }else{
            showSnackbar("Đăng nhập bằng Google thất bại");
          }
      }),
    ),);
  }
}