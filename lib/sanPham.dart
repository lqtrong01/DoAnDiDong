import 'package:flutter/material.dart';

class SanPham extends StatelessWidget {
  SanPham({super.key});

  void onDelete(){
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        height: 150.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 250, 250, 250),
          border: Border.all(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(12)
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                
                Column(
                  children: [
                    Image.asset('images/traixoai.jpg', height: 100.0, width: 100.0,)
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trái xoài',
                       style: TextStyle(
                        fontSize: 25,
                        color: Colors.black
                      )
                    ),

                    Text(
                      'trai xoai',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.remove
                        ),

                        Text(
                          '1',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),

                        Icon(
                          Icons.add_outlined
                        )
                      ],
                    )
                    
                  ],
                ),

                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Handle remove product
                        _deleteProduct(context);
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),

                    Text(
                      '\$4.99',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black
                      )
                    )
                  ]
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _deleteProduct(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa sản phẩm'),
          content: Text('Bạn có chắc muốn xóa sản phẩm này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),

            TextButton(
              onPressed: () {
                // Thực hiện logic xóa sản phẩm ở đây
                onDelete();
                
                // Sau khi xóa, bạn có thể cập nhật UI, ví dụ: xóa sản phẩm khỏi danh sách
                Navigator.of(context).pop(); // Đóng hộp thoại
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sản phẩm đã được xóa'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Xác nhận'),
            ),
          ],
        );
      },
    );
  }
}
