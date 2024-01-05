import 'package:app_thuong_mai/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BotNav extends StatelessWidget {
  const BotNav({super.key, required this.idx});
  final int idx;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    User? user = args?['user'];
    return BottomNavigationBar(
      backgroundColor: Color.fromARGB(26, 255, 255, 255),
      fixedColor: Colors.blueAccent,
      items: const [
        BottomNavigationBarItem(
          label: 'Trang chủ', icon: Icon(Icons.home_outlined)
        ),
        BottomNavigationBarItem(
          label: 'Giỏ hàng', icon: Icon(Icons.shopping_cart_outlined)
        ),
        BottomNavigationBarItem(
          label: 'Thông báo', icon: Icon(Icons.notifications_none_outlined)
        ),
        BottomNavigationBarItem(
          label: 'Cá nhân', icon: Icon(Icons.account_circle_outlined),
        )
      ],
      currentIndex: idx,
      onTap: (int indexOfItem) {
        if (indexOfItem == 0 && indexOfItem != idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (idx != indexOfItem)
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (indexOfItem == 1 && indexOfItem != idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (idx != indexOfItem)
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else if (indexOfItem == 2 && indexOfItem != idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (idx != indexOfItem) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        } else if (indexOfItem == 3 && indexOfItem != idx) {
          Navigator.popUntil(context, (route) => route.isFirst);
          if (idx != indexOfItem) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }
        }
      },
    );
  }
}
