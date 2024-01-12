import 'package:app_thuong_mai/Item/statistics_item.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Statistics extends StatefulWidget {
  Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  int? selectedMonth; // Giá trị mặc định cho tháng (null nếu chưa chọn)
  int? selectedYear;  // Giá trị mặc định cho năm (null nếu chưa chọn)

  final List<StatisticsItem> data = [
    StatisticsItem(
      year: '2022',
      month: '1',
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Colors.green),
    ),
    StatisticsItem(
      year: '2022',
      month: '2',
      financial: 200,
      color: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    StatisticsItem(
      year: '2022',
      month: '3',
      financial: 150,
      color: charts.ColorUtil.fromDartColor(Colors.red),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StatisticsItem, String>> series = [
      charts.Series(
        id: "financial",
        data: filteredData(),
        domainFn: (StatisticsItem series, _) => series.month,
        measureFn: (StatisticsItem series, _) => series.financial,
        colorFn: (StatisticsItem series, _) => series.color,
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
  List<StatisticsItem> filteredData() {
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