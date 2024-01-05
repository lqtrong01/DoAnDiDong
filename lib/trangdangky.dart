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
                  ElevatedButton(style:const ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color.fromRGBO(87, 175, 115, 100))),onPressed: () {
                    
                  }, child: const Text("Đăng ký",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0))),
                ],),
                Row(mainAxisAlignment: MainAxisAlignment.center,children: [ const
                  Text("Đã có tài khoản? ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0)),
                  TextButton(onPressed: () {
                    
                  }, child: const Text("Đăng nhập",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18.0,color: Color.fromRGBO(58, 185, 37, 100))),)
                ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}