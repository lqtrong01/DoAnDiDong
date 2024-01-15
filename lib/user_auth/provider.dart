import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}

Future<DatabaseReference> ReadData() async {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference myRef = database.ref().child('https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/');
  return _databaseReference;
}