import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: Text('Help', style: TextStyle(color: Colors.black),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.email),
                  title: Text('Thông tin liên hệ'),
                  subtitle: Text('0306211416@caothang.edu.vn'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.accessibility_sharp),
                  title: Text('Liên hệ hỗ trợ'),
                  subtitle: Text('19006067'),
                ),
              ),
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.person),
                  title: Text('Chat với nhân viên '),
                  subtitle: Text('Online trực tuyến'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
