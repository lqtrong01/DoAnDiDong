import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app_thuong_mai/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:Lottie.asset('assets/animationoder.json'),
      // Column(
      //   children: [
      //     Image.asset('asset/animationoder.json'),
      //     const Text("Cake app",style: TextStyle(fontSize: 40),)
      //   ],
      // ),
      backgroundColor: Colors.green,
      splashIconSize: 400,
      duration: 3000,
      splashTransition:SplashTransition.scaleTransition ,
      animationDuration: const Duration(seconds:2 ),
       nextScreen: const HomePage());
  }
}