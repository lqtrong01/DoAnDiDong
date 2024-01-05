import 'package:app_thuong_mai/Item/item.dart';
import 'package:app_thuong_mai/firebase_options.dart';
import 'package:app_thuong_mai/screen/home_screen.dart';
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
      debugShowCheckedModeBanner: false,
      routes: {
        '/':(context) => HomeScreen(),
        '/item':(context) => Item(path: 'assets/image/banana.png', name: 'name', price: 'price')
      },
      initialRoute: '/',
    );
  }
}
