import 'package:app_thuong_mai/firebase_options.dart';
import 'package:app_thuong_mai/screen/home_screen.dart';
import 'package:app_thuong_mai/screen/login_screen.dart';
import 'package:app_thuong_mai/screen/order_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Newsreader',
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login':(context) => LoginScreen()
      },
      initialRoute: '/login',
    );
  }
}
