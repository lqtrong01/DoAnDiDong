import 'package:app_thuong_mai/screennotification/notificationscreen.dart';
import 'package:app_thuong_mai/thanhtoan/order_pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'thongbao.dart';
import 'utils/custom_buttom.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Thông Báo"),
        centerTitle: true,
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomButtom(onPressed: (){
            // Notificationmanerger().clickshow();
            Navigator.push(context,MaterialPageRoute(builder: (context) => CartScreen(userToken: 0)));
          }, title: "Click"),
          SizedBox(height: 10,),
             CustomButtom(onPressed: (){
            // Notificationmanerger().clickshow();
            Navigator.push(context,MaterialPageRoute(builder: (context) => ThongbaoMua(userToken: 0)));
          }, title: "Clicks")
    
    
        ],
      )
    );
  }
}
