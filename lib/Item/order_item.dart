import 'package:app_thuong_mai/Item/order_detail.dart';
import 'package:flutter/material.dart';

class OrderItem extends StatelessWidget {
  final Text title;
  final String path;
  final String name;
  final String price;
  final String origin;
  final int quantity;
  final bool status;
  final int idx;
  const OrderItem({
    super.key, 
    required this.title, 
    required this.path, 
    required this.name, 
    required this.price, 
    required this.origin,
    required this.quantity,
    required this.status,
    required this.idx
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey)
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20.0,),
                Icon(Icons.shopping_bag_outlined),
                SizedBox(width: 20,),
                title,
              ],
            ),
          ),
          Divider(thickness: 2,),
          ListTile(
            leading: Image.network(path, width: 60, height: 60, fit: BoxFit.contain,),
            title: Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            subtitle: Text(origin),
            trailing: Text('x'+quantity.toString()+'\n'+price),
            onTap: (){
              try{
                Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetail(idx: idx, quantity: quantity, status: status)));
              }catch(e){
                print(e.toString());
              }
            },
          )
        ],
      ),
    );
  }
}