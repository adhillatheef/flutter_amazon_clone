import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/services/admin_service.dart';
import 'package:flutter_amazon_clone/widgets/chart_widget.dart';
import 'package:flutter_amazon_clone/widgets/loader.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

import '../model/sales_model.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  final AdminService adminService = AdminService();
  int? totalSales;
  List<Sales>? earnings;

  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminService.getEarnings(context);
    setState(() {
      totalSales = earningData['totalEarnings'];
      earnings = earningData['sales'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$$totalSales',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 250,
                child: Chart(seriesList: [
                  charts.Series(
                    id: 'sales',
                    data: earnings!,
                    domainFn: (Sales sales, _) => sales.label,
                    measureFn: (Sales sales, _) => sales.earning,
                  )
                ]),
              )
            ],
          );
  }
}
