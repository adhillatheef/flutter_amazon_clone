import 'package:flutter/material.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../model/sales_model.dart';

class Chart extends StatelessWidget {
  final List<charts.Series<Sales, String>> seriesList;
  const Chart({Key? key, required this.seriesList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}
