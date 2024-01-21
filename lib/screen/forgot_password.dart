import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController txt_emailToReset = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(message),
      ),
    );
  }

  Future<void> _forgotPassword(String email) async {
    try {
      // Kiểm tra tính hợp lệ của email
      if (RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$").hasMatch(email)) {
        await _auth.sendPasswordResetEmail(email: email);
        showSnackbar("Yêu cầu đã được gửi để đặt lại mật khẩu");
      } else {
        showSnackbar("Vui lòng nhập một địa chỉ email hợp lệ");
      }
    } catch (e) {
      print("Lỗi: $e");
      showSnackbar("Đã xảy ra lỗi khi gửi yêu cầu đặt lại mật khẩu");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: const Text(
            "Quên mật khẩu",
            style: TextStyle(fontSize: 32.0),
          ),
        ),
        Container(
          child: TextField(
            controller: txt_emailToReset,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.zero),
                borderSide: BorderSide(color: Colors.black, width: 0.1),
              ),
              hintText: "Email",
            ),
          ),
        ),
        Container(
          child: ElevatedButton(
            onPressed: () {
              if (txt_emailToReset.text.isNotEmpty) {
                _forgotPassword(txt_emailToReset.text);
              } else {
                showSnackbar("Vui lòng nhập địa chỉ email");
              }
            },
            child: Text("Đặt lại mật khẩu"),
          ),
        )
      ],
    );
  }
}