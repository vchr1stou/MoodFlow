import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'provider/statistics_mood_charts_provider.dart';

class StatisticsmoodTabPage extends StatefulWidget {
  const StatisticsmoodTabPage({Key? key}) : super(key: key);

  @override
  StatisticsmoodTabPageState createState() => StatisticsmoodTabPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodChartsProvider(),
      child: StatisticsmoodTabPage(),
    );
  }
}

class StatisticsmoodTabPageState extends State<StatisticsmoodTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 6.h),
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
