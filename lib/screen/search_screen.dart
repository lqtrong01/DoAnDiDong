import 'package:app_thuong_mai/Item/item.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final List<dynamic> lstSearch;
  final int userToken;
  const SearchScreen({super.key, required this.lstSearch, required this.userToken});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
        title: Text('Danh sách sản phẩm', style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: widget.lstSearch.length,
                  itemBuilder: (context, index) {
                    try{
                      if(widget.lstSearch[index]['quantity']>0){
                          return Item(
                          path: widget.lstSearch[index]['path'],
                          name: widget.lstSearch[index]['pro_name'],
                          price: widget.lstSearch[index]['price'],
                          origin: widget.lstSearch[index]['origin'],
                          idx: widget.lstSearch[index]['token'],
                          userToken: widget.userToken,
                        );
                      }
                      else {
                        return const SizedBox();
                      }
                    }
                    catch(e)
                    {
                      print(e.toString());
                    }
                    
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}