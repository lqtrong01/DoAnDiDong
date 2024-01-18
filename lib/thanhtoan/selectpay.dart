// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// class payselect extends StatefulWidget {
//   const payselect({super.key});

//   @override
//   State<payselect> createState() => _payselectState();
// }

// class _payselectState extends State<payselect> {
//  final List<String> items = [
//   'Item1',
//   'Item2',
//   'Item3',
//   'Item4',
// ];
// String? selectedValue;

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton2<String>(
//           isExpanded: true,
//           hint: Text(
//             'Select Item',
//             style: TextStyle(
//               fontSize: 14,
//               color: Theme.of(context).hintColor,
//             ),
//           ),
//           items: items
//               .map((String item) => DropdownMenuItem<String>(
//                     value: item,
//                     child: Text(
//                       item,
//                       style: const TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                   ))
//               .toList(),
//           value: selectedValue,
//           onChanged: (String? value) {
//             setState(() {
//               selectedValue = value;
//             });
//           },
//           buttonStyleData: const buttonStyleData(
//             padding: EdgeInsets.symmetric(horizontal: 16),
//             height: 40,
//             width: 140,
//           ),
//           menuItemStyleData: const menuItemStyleData(
//             height: 40,
//           ),
//         ),
//       ),
//     ),
//   );
// }
// }