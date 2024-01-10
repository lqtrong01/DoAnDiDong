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
  bool isCheckedVisiblePassword = false;
  int userCount = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserCount();
  }
  /* void registerUser(){
    String username = txt_username.text;
    String phone = txt_phone.text;
    String email = txt_email.text;
    String password = txt_password.text;
    DatabaseReference userReference = _databaseReference.child("users").child('user${userCount}').push();
     userReference.set({
      'username': username,
      'email': email,
      'phone': phone,
      'password': password,
    }).then((_) {
      print("User registered successfully");
      userCount++;
    }).catchError((error) {
      print("Error registering user: $error");
      // Handle error
    });
  } */

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

  void addNewUser() async {
    String userName = 'user${userCount}';
    String username = txt_username.text;
    String phone = txt_phone.text;
    String email = txt_email.text;
    String password = txt_password.text;
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _databaseReference.child('users').child('${userName}').child('detail').set({
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
        'token': userCount
      });
      showSnackbar('Tạo tài khoản thành công');
      userCount++;
      await _databaseReference.update({'userCount': userCount,});
    } catch (error) {
      showSnackbar('Tạo tài khoản thất bại');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset('assets/img/dangky.jpg',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                const Row(children: [
                   Text("Đăng ký", style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w500),textAlign: TextAlign.start,),
                ],),
                const Text("Nhập thông tin của bạn vào ô bên dưới để đăng ký", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),),
                const SizedBox(height: 7.0,),
                TextField(
                  controller: txt_username,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                    labelText: "Username",
                    hintText: "Nhập vào username",
                  ),
                ),
                const SizedBox(height: 7.0,),
                TextField(
                  controller: txt_phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.zero),borderSide: BorderSide(color: Colors.black,width: 0.1)),
                    labelText: "Phone",
                    hintText: "Nhập số điện thoại",
                  ),
                ),
                const SizedBox(height: 7.0,),
                TextFormField(
                  controller: txt_email,
                  keyboardType: TextInputType.emailAddress,
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
                    }, icon: isCheckedVisiblePassword?Icon(Icons.remove_red_eye):Icon(Icons.abc)),
                  ),
                ),
                const SizedBox(height: 18.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  Expanded(child: ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),onPressed: () {
                    setState(() {
                      if(txt_username!=null&&txt_phone!=null&&txt_email!=null&&txt_password!=null){
                        addNewUser();
                      }
                      
                    });
                  }, child: Container(child: Text("Đăng ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),)),)
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [ const
                  Text("Đã có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                  TextButton(onPressed: () {
                    setState(() {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, '/');
                    });
                  }, child: const Text("Đăng nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 1))),)
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}