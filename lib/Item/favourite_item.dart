import 'package:flutter/material.dart';

class FavouriteItem extends StatelessWidget {
  final String path;
  final String name;
  final String origin;
  final String price;
  final bool status;
  const FavouriteItem({super.key, required this.path, required this.name, required this.origin, required this.price, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey)
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(path, width: 60, height: 60, fit: BoxFit.contain,),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(origin),
            trailing: const Icon(Icons.arrow_forward_ios_outlined),
            onTap: (){
              
            },
          )
        ],
      ),
    );
  }
}