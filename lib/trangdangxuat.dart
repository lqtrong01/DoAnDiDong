import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final _googleSignIn = GoogleSignIn();

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      print("Đã đăng xuất thành công");
    } catch (error) {
      print("Lỗi đăng xuất: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: ElevatedButton(onPressed: () {
            setState(() {
              _handleSignOut();
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, '/');
            });
          }, child: Text("Đăng xuất")),
        ),
      ),
    );
  }
}