import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/app_export.dart';
import 'models/statistics_mood_drivers_model.dart';
import 'provider/statistics_mood_drivers_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../statistics_mood_charts_screen/statistics_mood_charts_screen.dart';

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
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/images/chevron.backward.svg',
                              width: 9,
                              height: 17,
                            ),
                            SizedBox(width: 6),
                            SelectableText(
                              'Back',
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                              enableInteractiveSelection: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  SelectableText(
                    'Statistics',
                    style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                    enableInteractiveSelection: false,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: 660.h,
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 6.h),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.maxFinite,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 8),
                          Expanded(
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    'assets/images/statistics_box.svg',
                                    width: 379,
                                    height: 661,
                                  ),
                                ),
                                Positioned(
                                  top: 18,
                                  child: _buildTabview(context),
                                ),
                                Positioned.fill(
                                  top: 62,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8.h),
                                    child: Column(
                                      children: [
                                        SizedBox(height: 18.h),
                                        SelectableText(
                                          "Mood Drivers",
                                          style: GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          enableInteractiveSelection: false,
                                        ),
                                        SizedBox(height: 16.h),
                                        Container(
                                          width: double.maxFinite,
                                          padding: EdgeInsets.all(16.h),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(32),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SelectableText(
                                                "Top Activities",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                enableInteractiveSelection: false,
                                              ),
                                              SizedBox(height: 8.h),
                                              SelectableText(
                                                "Exercise",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enableInteractiveSelection: false,
                                              ),
                                              SizedBox(height: 8.h),
                                              SelectableText(
                                                "Meditation",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enableInteractiveSelection: false,
                                              ),
                                              SizedBox(height: 8.h),
                                              SelectableText(
                                                "Sleep",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                enableInteractiveSelection: false,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabview(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/picker_mood_drivers_selected.svg',
            width: 330,
            height: 44,
          ),
          Positioned(
            left: 30.5,
            top: 11,
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => StatisticsMoodChartsScreen.builder(context),
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 24,
                child: SelectableText(
                  "Mood Charts",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.85),
                  ),
                  enableInteractiveSelection: false,
                ),
              ),
            ),
          ),
          Positioned(
            left: 193,
            top: 11,
            child: SelectableText(
              "Mood Drivers",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              enableInteractiveSelection: false,
            ),
          ),
        ],
      ),
    );
  }
}
