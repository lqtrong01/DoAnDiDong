// import 'package:flutter/material.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'namThongKe.dart';

// class ThongKe extends StatefulWidget {
//   ThongKe({Key? key}) : super(key: key);

//   @override
//   _ThongKeState createState() => _ThongKeState();
// }

// class _ThongKeState extends State<ThongKe> {
//   int selectedMonth = 1; // Giá trị mặc định cho tháng
//   int selectedYear = 2022; // Giá trị mặc định cho năm

//   final List<ThongKeModel> data = [
//     ThongKeModel(
//       year: '2022',
//       month: '1',
//       financial: 400,
//       color: charts.ColorUtil.fromDartColor(Colors.green),
//     ),
//     ThongKeModel(
//       year: '2022',
//       month: '2',
//       financial: 200,
//       color: charts.ColorUtil.fromDartColor(Colors.blue),
//     ),
//     ThongKeModel(
//       year: '2022',
//       month: '3',
//       financial: 150,
//       color: charts.ColorUtil.fromDartColor(Colors.red),
//     ),
//     // Thêm dữ liệu cho các tháng và năm khác nếu cần
//   ];

//   @override
//   Widget build(BuildContext context) {
//     List<charts.Series<ThongKeModel, String>> series = [
//       charts.Series(
//         id: "financial",
//         data: filteredData(),
//         domainFn: (ThongKeModel series, _) => series.month, // Sử dụng tháng làm domain
//         measureFn: (ThongKeModel series, _) => series.financial,
//         colorFn: (ThongKeModel series, _) => series.color,
//       )
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Thống Kê"),
//         centerTitle: true,
//         backgroundColor: Colors.green[700],
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
//         child: Column(
//           children: [
//             DropdownButton<int>(
//               value: selectedMonth,
//               items: List.generate(12, (index) {
//                 return DropdownMenuItem<int>(
//                   value: index + 1,
//                   child: Text((index + 1).toString()),
//                 );
//               }),
//               onChanged: (int? newValue) {
//                 setState(() {
//                   selectedMonth = newValue!;
//                 });
//               },
//             ),
//             DropdownButton<int>(
//               value: selectedYear,
//               items: <int>[2020, 2021, 2022, 2023].map((int value) {
//                 return DropdownMenuItem<int>(
//                   value: value,
//                   child: Text(value.toString()),
//                 );
//               }).toList(),
//               onChanged: (int? newValue) {
//                 setState(() {
//                   selectedYear = newValue!;
//                 });
//               },
//             ),
//             // Sử dụng SizedBox để cung cấp chiều cao cố định cho BarChart
//             SizedBox(
//               height: 300,
//               child: charts.BarChart(
//                 series,
//                 animate: true,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Hàm để lọc dữ liệu theo tháng và năm
//   List<ThongKeModel> filteredData() {
//     return data
//         .where((entry) =>
//             entry.month == selectedMonth.toString() ||
//             entry.year == selectedYear.toString())
//         .toList();
//   }
// }


import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'namThongKe.dart';

class ThongKe extends StatefulWidget {
  ThongKe({Key? key}) : super(key: key);

  @override
  _ThongKeState createState() => _ThongKeState();
}

class _ThongKeState extends State<ThongKe> {
  int? selectedMonth; // Giá trị mặc định cho tháng (null nếu chưa chọn)
  int? selectedYear;  // Giá trị mặc định cho năm (null nếu chưa chọn)

  final List<ThongKeModel> data = [
    ThongKeModel(
      year: '2022',
      month: '1',
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    ThongKeModel(
      year: '2022',
      month: '2',
      financial: 200,
      color: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    ThongKeModel(
      year: '2022',
      month: '3',
      financial: 150,
      color: charts.ColorUtil.fromDartColor(Colors.red),
    ),
    // Thêm dữ liệu cho các tháng và năm khác nếu cần
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ThongKeModel, String>> series = [
      charts.Series(
        id: "financial",
        data: filteredData(),
        domainFn: (ThongKeModel series, _) => series.month,
        measureFn: (ThongKeModel series, _) => series.financial,
        colorFn: (ThongKeModel series, _) => series.color,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Thống Kê"),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          children: [

            // ComboBox cho tháng
            DropdownButton<int?>(
              value: selectedMonth,
              items: getMonthDropdownItems(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedMonth = newValue;
                });
              },
            ),

            // ComboBox cho năm
            DropdownButton<int?>(
              value: selectedYear,
              items: getYearDropdownItems(),
              onChanged: (int? newValue) {
                setState(() {
                  selectedYear = newValue;
                });
              },
            ),
            
            // Biểu đồ
            SizedBox(
              height: 300,
              child: charts.BarChart(
                series,
                animate: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm để lọc dữ liệu theo tháng và năm
  List<ThongKeModel> filteredData() {
    return data
        .where((entry) =>
            (selectedMonth == null || entry.month == selectedMonth.toString()) &&
            (selectedYear == null || entry.year == selectedYear.toString()))
        .toList();
  }

  // Hàm để lấy danh sách lựa chọn cho ComboBox tháng
  List<DropdownMenuItem<int?>> getMonthDropdownItems() {
    List<int?> months = [null, for (int i = 1; i <= 12; i++) i];
    return months.map((int? value) {
      return DropdownMenuItem<int?>(
        value: value,
        child: Text(value == null ? 'Tất cả' : value.toString()),
      );
    }).toList();
  }

  // Hàm để lấy danh sách lựa chọn cho ComboBox năm
  List<DropdownMenuItem<int?>> getYearDropdownItems() {
    List<int?> years = [null, 2020, 2021, 2022, 2023]; // Thêm năm "Tất cả" nếu cần
    return years.map((int? value) {
      return DropdownMenuItem<int?>(
        value: value,
        child: Text(value == null ? 'Tất cả' : value.toString()),
      );
    }).toList();
  }
}