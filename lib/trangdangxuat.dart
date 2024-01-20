import 'package:app_thuong_mai/loadingscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  final _googleSignIn = GoogleSignIn();
  bool isLoading = false;

  Future<void> _signOutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('savedEmail', '');
    prefs.setString('savedPassword', '');
    prefs.remove('saveUser');
    print("Đăng xuất E/P thành công");
    print(prefs.getBool('saveUser'));
    print(prefs.getString('savedEmail'));
    print(prefs.getString('savedPassword'));
  }

  Future<void> _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      await _signOutUser();
      print("Đã đăng xuất thành công");
    } catch (error) {
      print("Lỗi đăng xuất: $error");
    }
  }

  @override
  Widget build(BuildContext context) => isLoading
    ? LoadingScreen() : _LogoutScreen();

  Widget _LogoutScreen(){
    return Scaffold(
      body: Center(
        child: Container(
          child: ElevatedButton(onPressed: () async {
            setState(() {
              isLoading=true;
              _handleSignOut();
            });
            await Future.delayed(const Duration(seconds: 2));
            setState(() {
              isLoading=false;
              /* SharedPreferences pref = await SharedPreferences.getInstance();
              await pref.remove('saveFirstUse'); */
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, '/');
            });
          }, child: Text("Đăng xuất")),
        ),
      ),
    );
  }
}