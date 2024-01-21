import 'package:app_thuong_mai/Item/detail_item.dart';
import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  final String path;
  final String name;
  final String price;
  final String origin;
  final int idx;
  final int userToken;

  const Item({
    Key? key,
    required this.path,
    required this.name,
    required this.price,
    required this.origin,
    required this.idx,
    required this.userToken
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => DetailItem(idx: idx,userToken: userToken,)
          )
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: const Color.fromRGBO(196, 198, 198, 1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              path,
              height: 50.0,
              width: 50.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6.0,),
            Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20.0,),
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ),
            Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 20.0,),
                  Text(
                    origin,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ),
            Container(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Price: ${price.toString()}',
                  ),
                  IconButton(
                    onPressed: (){
                      try
                      {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => DetailItem(idx: idx,userToken: userToken,)
                          )
                        );
                      }
                      catch(e){
                        print(e.toString());
                      }
                    },
                    icon: const Icon(Icons.add_box_outlined),
                    color: const Color.fromRGBO(87, 175, 115, 1),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
