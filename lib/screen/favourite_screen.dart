import 'package:app_thuong_mai/Item/favourite_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FavouriteScreen extends StatefulWidget {
  final int userToken;
  const FavouriteScreen({super.key, required this.userToken});

  @override
  State<FavouriteScreen> createState() => _favouriteScreenState();
}

class _favouriteScreenState extends State<FavouriteScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  final List<Map<dynamic, dynamic>> user = [];
  final List<dynamic> lst_favourite = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }
  
  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user.add(value);
        });
        try{
          for (var value in user[widget.userToken]['favourites']) {
            lst_favourite.add(value);
          }
        }
        catch(e){
          print('error'+e.toString());
        }
        print(user.length);
        print(lst_favourite);
        print(lst_favourite.length);
        setState(() {
          
        }); // Trigger a rebuild with the fetched data
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }


  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  String titleOrder = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: Text('Đơn hàng', style: TextStyle(color: Colors.black),),
      ),
      body: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: lst_favourite.length,
          itemBuilder: (context, index){
            try{
              return FavouriteItem(
                path: user[widget.userToken]['orders'][index]['path'], 
                name: user[widget.userToken]['orders'][index]['name'], 
                origin: user[widget.userToken]['orders'][index]['origin'], 
                price: user[widget.userToken]['orders'][index]['price'], 
                status: user[widget.userToken]['orders'][index]['status']
              );
            }catch(e){
              print(e.toString());
            }
          }
        ),
    );
  }
}