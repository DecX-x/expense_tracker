import 'package:expense_tracker/bar%20_graph/in_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MybarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startmonth;

  const MybarGraph({
    super.key,
    required this.monthlySummary,
    required this.startmonth,
    });

  @override
  State<MybarGraph> createState() => _MybarGraphState();
}

class _MybarGraphState extends State<MybarGraph> {

  List<IndividualBar> barData = [];

  void initializeBarData() {
    barData = List.generate(widget.monthlySummary.length, 
    (index) => IndividualBar(x: index, y: widget.monthlySummary[index]));
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: 100
      )
    );
  }
}