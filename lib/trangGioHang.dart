import 'package:app_thuong_mai/sanPham.dart';
import 'package:flutter/material.dart';

class GioHang extends StatefulWidget {
  const GioHang({super.key});

  @override
  State<GioHang> createState() => _GioHangState();
}

class _GioHangState extends State<GioHang> {

   final List<SanPham> sanPham = [
      SanPham(),
      SanPham(),
      SanPham(),
      SanPham(),
      SanPham()
   ];


  //thanh toán
  void payNow(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Xác Nhận Thanh Toán"),
          content: Text("Bạn muốn thanh toán không?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("Hủy"),
            ),
            TextButton(
              onPressed: () {
                // Gọi hàm thanh toán ở đây nếu cần
                // payNow();
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text("Thanh Toán"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            
            //heading
            Text(
              'Giỏ hàng',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),

            //list of cart items
            Expanded(
              child: ListView.builder(
                itemCount: sanPham.length,
                itemBuilder:  (context, index){
                  return sanPham[index];
                } 
              )
            ),
            

            //pay button
            GestureDetector(
              onTap: payNow,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12)
                ),
                child: const Center(
                  child: Text(
                    "Thanh Toán",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}