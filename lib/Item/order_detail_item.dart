import 'package:app_thuong_mai/Item/detail_item.dart';
import 'package:flutter/material.dart';

class OrderDetailItem extends StatelessWidget {
  final String path;
  final String name;
  final String origin;
  final String price;
  final int quantity;
  final int token;
  final int userToken;
  const OrderDetailItem({
    super.key, 
    required this.path, 
    required this.name, 
    required this.origin, 
    required this.price,
    required this.quantity,
    required this.token,
    required this.userToken
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey)
      ),
      child: Column(
        children: [
          ListTile(
            leading: Image.network(path, width: 60, height: 60, fit: BoxFit.contain,),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(origin),
            trailing: Text('x'+quantity.toString()+'\n'+price),
            // onTap: (){
            //   try{
            //     Navigator.pop(context);
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailItem(idx: token, userToken: userToken)));
            //   }catch(e){
            //     print(e.toString());
            //   }
            // },
          )
        ],
      ),
    );
  }
}