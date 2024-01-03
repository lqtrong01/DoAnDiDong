import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController txt_username = TextEditingController();
  TextEditingController txt_email = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  bool isCheckedVisiblePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [ 
                const Row(children: [
                   Text("Đăng ký", style: TextStyle(fontSize: 32.0,fontWeight: FontWeight.w800),textAlign: TextAlign.start,),
                ],),
                const Text("Nhập thông tin của bạn vào ô để đăng ký tài khoản", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),),
                TextField(
                  controller: txt_username,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    hintText: "Nhập vào username",
                  ),
                ),
                TextField(
                  controller: txt_email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "Nhập vào email",
                  ),
                ),
                TextField(
                  obscureText: isCheckedVisiblePassword,
                  controller: txt_password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Nhập vào password",
                    suffixIcon: IconButton(onPressed: () {
                      isCheckedVisiblePassword=!isCheckedVisiblePassword;
                      setState(() {
                        
                      });
                    }, icon: isCheckedVisiblePassword?Icon(Icons.remove_red_eye):Icon(Icons.abc)),
                  ),
                ),
                const SizedBox(height: 20.0,),
                ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(58, 185, 37, 100))),onPressed: () {
                  
                }, child: const Text("Đăng ký")),
                Row(children: [ const
                  Text("Đã có tài khoản? "),
                  TextButton(onPressed: () {
                    
                  }, child: Text("Đăng nhập",style: TextStyle(color: Color.fromRGBO(58, 185, 37, 100))),)
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}