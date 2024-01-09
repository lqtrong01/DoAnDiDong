import 'package:app_thuong_mai/thongKe.dart';
import 'package:app_thuong_mai/trangGioHang.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GioHang(),
    );
  }
}

