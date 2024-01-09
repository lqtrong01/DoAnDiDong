import 'package:charts_flutter/flutter.dart' as charts;

class ThongKeModel {
  String year;
  String month;
  int financial;
  final charts.Color color;

  ThongKeModel({
    required this.year, 
    required this.month, 
    required this.financial, 
    required this.color
  });
}