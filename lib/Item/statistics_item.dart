import 'package:charts_flutter/flutter.dart' as charts;

class StatisticsItem {
  String year;
  String month;
  int financial;
  final charts.Color color;

  StatisticsItem({
    required this.year, 
    required this.month, 
    required this.financial, 
    required this.color
  });
}