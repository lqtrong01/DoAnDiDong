
import 'package:app_thuong_mai/main.dart';
import 'package:flutter/material.dart';

class NotificationItem extends StatelessWidget {
  final String title;

  const NotificationItem({
    super.key, 
    required this.title, 
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.lightGreenAccent)
      ),
      child: Column(
        children: [
          ListTile(
            onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            leading: Icon(Icons.notifications_active,color: Colors.amber,),
            title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.black),),
            trailing: null,
          ),
        ],
      ),
    );
  }
}