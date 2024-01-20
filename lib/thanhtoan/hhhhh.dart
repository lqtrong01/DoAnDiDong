

// import 'package:flutter/material.dart';

// class ordername extends StatelessWidget {
//   final String name;
//   final String location;
//   final String phone;
  
//   final int idx;
//   const ordername({
//     super.key, 
//     required this.name, 
//     required this.location,
//     required this.phone,
//     required this.idx
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Column(
//         children: [
//           ListTile(
//             title:Container(child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
//               Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
//               Text('(+84) '+phone, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
//               Text(location, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color.fromRGBO(96, 96, 96, 1)),),
//             ],
//             ),),
//             onTap: (){
//               try{
                
//               }catch(e){
//                 print(e.toString());
//               }
//             },
//           )
//         ],
//       ),
//     );
//   }
// }