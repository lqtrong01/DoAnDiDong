import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsScreen extends StatefulWidget {
  final int userToken;

  const StatisticsScreen({
    super.key,
    required this.userToken
  });

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class StatisticsItem{
  final int month;
  final double financial;
  final charts.Color color;

  StatisticsItem({
    required this.month,
    required this.financial,
    required this.color
  });
}


class _StatisticsScreenState extends State<StatisticsScreen> {

  final DatabaseReference _databaseReference = FirebaseDatabase(
    databaseURL:
        'https://app-thuong-mai-ndtt-default-rtdb.asia-southeast1.firebasedatabase.app/',
  ).reference();

  //Danh sách người dùng
  List<Map<dynamic, dynamic>> user = [];

  //Danh sách giỏ hàng
  List<dynamic> lst_orders = [];

  int? selectedMonth; // Giá trị mặc định cho tháng (null nếu chưa chọn)
  int? selectedYear;  // Giá trị mặc định cho năm (null nếu chưa chọn)

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      DatabaseEvent event = await _databaseReference.once();
      DataSnapshot? dataSnapshot = event.snapshot;

      if (dataSnapshot != null && dataSnapshot.value != null) {
        List<dynamic> data = (dataSnapshot.value as Map)['users'];
        data.forEach((value) {
          user.add(value);
        });
        for(var value in user[widget.userToken]['orders']){
          lst_orders.add(value);
        }
        print(lst_orders);
        print(lst_orders.length);
        setState(() {});
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  late String date;
  late String total;

  // Hàm tách chuỗi lấy tháng, năm trong dánh sách thành toán
  int TachChuoi(String date, String type) {
    DateTime dateTime = DateTime.parse(date + 'z');

    if(type == 'month') {
      return dateTime.month;
    }
    else if(type == 'year') {
      return dateTime.year;
    }
    else 
      return 0;
  }

  // Hàm tính tổng total năm
  double tinhTongTheoNam(int nam) {

    double tong = 0.0;

    for (int i = 0; i < lst_orders.length; i++) {

      date = user[widget.userToken]['orders'][i][0]['ddmmyy'];
      total = user[widget.userToken]['orders'][i][0]['total'];

      int year = TachChuoi(date, 'year');

      if (year == nam) {
        tong += double.parse(total);
      }
    }
    return tong;
  }

  // Hàm tính tổng total tháng
  double tinhTongTheoThang(int thang, int nam) {

    double tong = 0.0;

    for (int i = 0; i < lst_orders.length; i++) {

      date = user[widget.userToken]['orders'][i][0]['ddmmyy'];
      total = user[widget.userToken]['orders'][i][0]['total'];

      int month = TachChuoi(date, 'month');
      int year = TachChuoi(date, 'year');

      if (month == thang && year == nam) {
        tong += double.parse(total);
      }
    }
    return tong;
  }

  List<charts.Series<StatisticsItem, String>> getChartSeries() {

    List<StatisticsItem> data = [];

    for (int i = 0; i < lst_orders.length; i++) {

      date = user[widget.userToken]['orders'][i][0]['ddmmyy'];
      
      int month = TachChuoi(date, 'month');
      int year = TachChuoi(date, 'year');

      if((selectedMonth == null || month == selectedMonth) &&
        (selectedYear == null || year == selectedYear)) {
        double tongTheoThang = tinhTongTheoThang(month, year);

        data.add(
          StatisticsItem(
            month: month,
            financial: tongTheoThang,
            color: charts.MaterialPalette.gray.shadeDefault,
          )
        );
      }
    }

    return [
      charts.Series(
        id: "financial",
        data: data,
        domainFn: (StatisticsItem series, _) => series.month.toString(),
        measureFn: (StatisticsItem series, _) => series.financial,
        colorFn: (StatisticsItem series, _) => series.color,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        iconTheme: const IconThemeData(
          color: Colors.black
        ),
          backgroundColor: Colors.white,
          leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        title: const Text(
          'Thống kê', 
          style: TextStyle(
            color: Colors.black
          ),
        ),
      ),

      body: Column(
        children: [

          // ComboBox tháng
          DropdownButton<int?>(
            value: selectedMonth,
            items: getMonthDropdownItems(),
            onChanged: (int? newValue) {
              setState(() {
                selectedMonth = newValue;
              });
            },
          ),

          // ComboBox năm
          DropdownButton<int?>(
            value: selectedYear,
            items: getYearDropdownItems(),
            onChanged: (int? newValue) {
              setState(() {
                selectedYear = newValue;
              });
            },
          ),

          // Biểu đồ thống kê
          Container(
            height: 200,
            child: charts.BarChart(
              getChartSeries(),
              animate: true,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm danh sách các tháng của combobox tháng
  List<DropdownMenuItem<int?>> getMonthDropdownItems() {

    List<int> lst_month = lst_orders.map((order){
      date = order[0]['ddmmyy'];
      return TachChuoi(date, 'month');
    }).toSet().toList();

    lst_month.sort();

    List<int?> months = [
      null, 
      ...lst_month
    ];

    return months.map((int? value) {

      return DropdownMenuItem<int?>(
        value: value,
        child: Text(value == null ? 'Tất cả các tháng có trong năm' : value.toString()),
      );
    }).toList();
  }

  // Hàm danh sách các năm của combobox năm
  List<DropdownMenuItem<int?>> getYearDropdownItems() {

    List<int> lst_year = lst_orders.map((order){
      date = order[0]['ddmmyy'];
      return TachChuoi(date, 'year');
    }).toSet().toList();

    lst_year.sort();

    List<int?> years = [
      null,
      ...lst_year
    ];

    return years.map((int? value) {

      return DropdownMenuItem<int?>(
        value: value,
        child: Text(value == null ? 'Năm' : value.toString()),
      );
    }).toList();
  }
}

// Expanded(
//   child: ListView.separated(
//     itemCount: lst_orders.length,
//     separatorBuilder: (BuildContext context, int index) => Divider(),
//     itemBuilder: (context, index) {
//       String date = lst_orders[index][0]['ddmmyy'];
//       String total = lst_orders[index][0]['total'];
//       int month = TachChuoi(date, 'month');
//       int year = TachChuoi(date, 'year');
//       double tongTheoNam = tinhTongTheoNam(year);
//       double tongTheoThang = tinhTongTheoThang(month, year);
//       return Column(
//         children: [
//           Text('$month'),
//           Text('$year'),
//           Text('$total'),
//           Text('$tongTheoNam'),
//           Text('$tongTheoThang'),
//         ],
//       );
//     },
//   ),
// ),
// int month = 0;
// int year = 0;
// try{
//   for(int i = 0; i < lst_orders.length; i++) {
//     date = user[widget.userToken]['orders'][i][0]['ddmmyy'];
//     print(date);
//     total = user[widget.userToken]['orders'][i][0]['total'];
//     print(total);
//     month = TachChuoi(date, 'month');
//     print(month);
//     year = TachChuoi(date, 'year');
//     print(year);
//   }
// }
// catch(e)
// {
//   print(e.toString());
// }