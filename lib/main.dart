import 'package:app_thuong_mai/firebase_options.dart';
import 'package:app_thuong_mai/google_sign_in.dart';
import 'package:app_thuong_mai/trangdangky.dart';
import 'package:app_thuong_mai/trangdangnhap.dart';
import 'package:app_thuong_mai/trangdangxuat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Newsreader',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/':(context) => const LoginScreen(),
        '/register':(context) => const RegisterScreen(),
        '/logout':(context) => const LogoutScreen(),
      }
    );
  }
}