import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import 'models/statistics_mood_drivers_model.dart';
import 'provider/statistics_mood_drivers_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class StatisticsMoodDriversPage extends StatefulWidget {
  const StatisticsMoodDriversPage({Key? key}) : super(key: key);

  @override
  StatisticsMoodDriversPageState createState() => StatisticsMoodDriversPageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsMoodDriversProvider(),
      child: Builder(
        builder: (context) => StatisticsMoodDriversPage(),
      ),
    );
  }
}

class StatisticsMoodDriversPageState extends State<StatisticsMoodDriversPage>
    with AutomaticKeepAliveClientMixin<StatisticsMoodDriversPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 8.h),
          child: Column(
            children: [
              SizedBox(height: 18.h),
              Text(
                "lbl_mood_drivers".tr(),
                style: theme.textTheme.titleLarge,
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.all(16.h),
                decoration: AppDecoration.windowsGlass.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder32,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "lbl_top_activities".tr(),
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_exercise".tr(),
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_meditation".tr(),
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "lbl_sleep".tr(),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
