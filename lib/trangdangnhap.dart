import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txt_username = TextEditingController();
  TextEditingController txt_password = TextEditingController();
  bool isCheckedVisiblePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: Image.asset('assets/img/dangnhap.jpg',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,)),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Get your groceries with Vephenomsoft",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 32.0),),
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
                const SizedBox(height: 25.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 1))),onPressed: () {
                    
                  }, child: const Text("Đăng nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)))
                ],),
                const SizedBox(height: 30.0,),
                const Text("Hoặc",style: TextStyle(fontWeight: FontWeight.w300,fontSize: 18.0),),
                const SizedBox(height: 20.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(91, 127, 238, 1))),onPressed: () {
                    
                  }, child: const Text("G       Tiếp tục với Google",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)))
                ],),
                const SizedBox(height: 20.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [ const
                  Text("Chưa có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                  TextButton(onPressed: () {
                    
                  }, child: const Text("Đăng ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 1))),)
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}