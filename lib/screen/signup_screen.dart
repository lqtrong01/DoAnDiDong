import 'package:animate_do/animate_do.dart';
import 'package:app_thuong_mai/screen/loading_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController txt_username = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_phone = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  bool isCheckedVisiblePassword = true;
  bool isEmailValid=false;
  bool isPhoneValid=false;
  bool isLoading = false;
  int userCount = 0;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  @override
  void initState() {
    _loadUserCount();
    isCheckedVisiblePassword=true;
    super.initState();
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

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
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

  void addNewUser() async {
    String username = txt_username.text;
    String phone = txt_phone.text;
    String email = txt_email.text.toLowerCase();
    String password = txt_password.text;
    bool isExisting = await _isExistingUser(email);
    if(!isExisting){
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String userId = userCredential.user!.uid;

        await _databaseReference.child('users').child('$userCount').set({
          'categoryCount': 0,
          'orderCount': 0,
          'notificationCount':0,
          'favouriteCount':0,
        });

        await _databaseReference.child('users').child('$userCount').child('detail').set({
          'avatar': "",
          'name': username,
          'phone': phone,
          'email': email.toLowerCase(),
          'location':"",
          'password': password,
          'token': userCount,
          'userID': userId,
        });
        showSnackbar('Tạo tài khoản thành công');
        userCount++;
        await _databaseReference.update({'userCount': userCount,});
      } catch (error) {
        showSnackbar('Tạo tài khoản thất bại');
      }
    }else{
      showSnackbar("Email đã tồn tại");
    }
  }

  @override
  Widget build(BuildContext context) => isLoading
    ? LoadingScreen()
    : Scaffold(
      body: SingleChildScrollView(child: Column(
        children: [
          Stack(children: [
            FadeInDown(duration: const Duration(seconds: 1),
              child: Container(child: Image.asset('assets/img/dangky.jpg',
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2-90,),
          ),),
            Positioned(
              left: 135.0,
              top: 220.0,
              child: FadeInUp(delay: const Duration(milliseconds: 100), duration: const Duration(seconds: 1),
                child: const Text("REGISTER", style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.w600, color: Colors.white))),),
          ],),
          Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                FadeInLeft(delay: const Duration(milliseconds: 200), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),child: const Text("Đăng ký", style: TextStyle(color: Colors.black,fontSize: 32.0,fontWeight: FontWeight.w500),textAlign: TextAlign.start,)),),
                FadeInRight(delay: const Duration(milliseconds: 300), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),child: const Text("Nhập thông tin của bạn vào ô bên dưới để đăng ký", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),)),),
                FadeInDown(delay: const Duration(milliseconds: 400), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextField(
                      controller: txt_username,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Username",
                      ),
                    ),
                  ),
                ),
                FadeInDown(delay: const Duration(milliseconds: 500), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextField(
                      controller: txt_phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          isPhoneValid =_isValidPhone(value);
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Phone",
                        suffixIcon: isPhoneValid ? Icon(Icons.check,color: Color.fromRGBO(87, 175, 115, 1),):null,
                      ),
                    ),
                  ),
                ),
                FadeInDown(delay: const Duration(milliseconds: 600), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextField(
                      controller: txt_email,
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        setState(() {
                          isEmailValid = _isValidEmail(value);
                        });
                      },
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Email",
                        suffixIcon: isEmailValid ? Icon(Icons.check,color: Color.fromRGBO(87, 175, 115, 1),):null,
                      ),
                    ),
                  ),
                ),
                FadeInDown(delay: const Duration(milliseconds: 700), duration: const Duration(seconds: 1),
                  child: Container(padding: const EdgeInsets.only(bottom: 7.0),
                    child: TextField(
                      obscureText: isCheckedVisiblePassword,
                      controller: txt_password,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                        hintText: "Password",
                        suffixIcon: IconButton(onPressed: () {
                          isCheckedVisiblePassword=!isCheckedVisiblePassword;
                          setState(() {
                            
                          });
                        }, icon: isCheckedVisiblePassword?Icon(Icons.visibility_off):Icon(Icons.visibility)),
                      ),
                    ),
                  ),
                ),
                FadeInUp(delay: const Duration(milliseconds: 800), duration: const Duration(seconds: 1),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Expanded(child: ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),onPressed: () {
                    setState(() {
                      if(txt_username!=null&&txt_password!=null&&isEmailValid&&isPhoneValid){
                        addNewUser();
                        resetData();
                      }else{
                        showSnackbar('SĐT hoặc Email không hợp lệ!');
                      }
                    });
                  }, child: Text("Đăng Ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),)),
                ],),),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  FadeInLeft(delay: const Duration(milliseconds: 900), duration: const Duration(seconds: 1),
                    child: Text("Đã có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),),
                  FadeInRight(delay: const Duration(milliseconds: 1000), duration: const Duration(seconds: 1),
                    child: TextButton(onPressed: () async{
                      setState(() {
                        isLoading=true; 
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      setState(() {
                        isLoading=false;
                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(context, '/login');
                      });
                  }, child: const Text("Đăng nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 1))),)),
                ],)
              ],
            ),
          )
        ],
      ),),
    );

  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneregex = 
        RegExp(r'^(03[2-9]|07[0|6|7|8|9]|08[1|2|3|4|5]|09[0|1|2|3|4|5|6|7|8|9])+([0-9]{7})\b');
    return phoneregex.hasMatch(phone);
  }

  void resetData(){
    txt_username.clear();
    txt_phone.clear();
    txt_email.clear();
    txt_password.clear();
    isEmailValid=false;
    isPhoneValid=false;
  }
}