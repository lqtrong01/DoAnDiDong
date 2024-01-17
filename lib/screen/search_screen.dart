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
                    return Item(
                      path: widget.lstSearch[index]['path'],
                      name: widget.lstSearch[index]['pro_name'],
                      price: widget.lstSearch[index]['price'],
                      origin: widget.lstSearch[index]['origin'],
                      idx: index,
                      userToken: widget.userToken,
                    );
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