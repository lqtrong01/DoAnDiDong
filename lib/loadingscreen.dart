import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(87, 175, 115, 1),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50.0,
                height: 50.0,
                child: const SpinKitSquareCircle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 50),
            child: TweenAnimationBuilder(
              duration: const Duration(seconds: 3),
              tween: ColorTween(begin: Colors.white, end: const Color.fromRGBO(87, 175, 115, 1)), // Chuyển đổi màu từ trắng sang xanh dương
              builder: (_, Color? color,__) {
                return Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Loading ",
                      style: TextStyle(
                        color: color,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}