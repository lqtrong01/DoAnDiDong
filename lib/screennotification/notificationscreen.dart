import 'package:flutter/material.dart';

class ThongbaoMua extends StatefulWidget {
  const ThongbaoMua({super.key});

  @override
  State<ThongbaoMua> createState() => _ThongbaoMuaState();
}

class _ThongbaoMuaState extends State<ThongbaoMua> {
  final notifications = [
    'Bạn vừa thanh toán thành công một đơn hàng',
    'Bạn vừa hủy thành công một đơn hàng',
    'Bạn vừa hủy thành công một đơn hàng',
    'Bạn vừa thanh toán thành công một đơn hàng',
    'Bạn vừa thanh toán thành công một đơn hàng',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông báo'),
      ),
      body: notifications.isEmpty
          ?Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Icon(Icons.notifications, size: 50, color: Colors.yellow),
              SizedBox(height: 30,),
              Text('Không có thông báo', style: TextStyle(color: Colors.green, fontSize: 20)),
              SizedBox(height: 10,),
              ElevatedButton(
                onPressed: () {},
                child: Text('Quay về Trang Chủ'),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ],
          ),
        )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key(notification),
                  onDismissed: (direction) {
                    setState(() {
                      notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$notification xóa')),
                    );
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    leading: Icon(Icons.notifications, color: Colors.amber),
                    title: Text(notification),
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.amber,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.blue), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart, color: Colors.blue), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications, color: Colors.blue),
              label: 'Thông báo'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, color: Colors.blue), label: 'Tôi'),
        ],
      ),
    );
  }
}