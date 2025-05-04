import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/streak_model.dart';
import 'provider/streak_provider.dart';

class StreakScreen extends StatefulWidget {
  const StreakScreen({Key? key}) : super(key: key);

  @override
  StreakScreenState createState() => StreakScreenState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StreakProvider(),
      child: Builder(
        builder: (context) => StreakScreen(),
      ),
    );
  }
}

class StreakScreenState extends State<StreakScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: appTheme.gray6004c,
      body: Container(
        width: double.maxFinite,
        height: SizeUtils.height,
        decoration: AppDecoration.gradientAmberToRed400,
        child: SafeArea(
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 26.h),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: _buildAppbar(context),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgVectorOrange400,
                      height: 142.h,
                      width: 110.h,
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      width: double.maxFinite,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "A streak is your",
                              style: CustomTextStyles.titleSmallRoboto14,
                            ),
                            TextSpan(
                              text: "Each day you",
                              style: CustomTextStyles.titleMediumOnPrimary,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildRowLongestStreak(context),
                    SizedBox(height: 16.h),
                    CustomOutlinedButton(
                      height: 50.h,
                      text: "Quick 7 hours",
                      margin: EdgeInsets.symmetric(horizontal: 30.h),
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineTL24Decoration,
                      buttonTextStyle: CustomTextStyles.labelLargeRoboto,
                      hasBlurBackground: true,
                    ),
                    SizedBox(height: 18.h),
                    _buildCalendarOne(context),
                    SizedBox(height: 42.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 30.h,
      actions: [
        AppbarTrailingIconbutton(
          imagePath: ImageConstant.imgClose,
          margin: EdgeInsets.only(right: 24.h),
        ),
      ],
    );
  }

  Widget _buildRowLongestStreak(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 30.h),
      child: Row(
        children: [
          Expanded(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: AppDecoration.windowsGlassBlur.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder32),
                  child: Column(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Longest streak",
                        style: CustomTextStyles.labelLargeRoboto,
                      ),
                      Text(
                        "152 days",
                        style: CustomTextStyles.labelLargeRobotoMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(left: 30.h, top: 8.h, bottom: 8.h),
                  decoration: AppDecoration.windowsGlassBlur.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder32),
                  child: Column(
                    spacing: 6,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Current streak",
                        style: CustomTextStyles.labelLargeRoboto,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "7 days",
                          style: CustomTextStyles.labelLargeRobotoMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarOne(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Consumer<StreakProvider>(
        builder: (context, provider, child) {
          return Container(
            height: 314.h,
            width: 354.h,
            margin: EdgeInsets.symmetric(horizontal: 24.h),
            child: CalendarDatePicker2(
              config: CalendarDatePicker2Config(
                calendarType: CalendarDatePicker2Type.multi,
                firstDate: DateTime(DateTime.now().year - 5),
                lastDate: DateTime(DateTime.now().year + 5),
                selectedDayHighlightColor: Color(0X99FF9500),
                firstDayOfWeek: 0,
                weekdayLabelTextStyle: TextStyle(
                  color: appTheme.gray700,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w600,
                ),
                selectedDayTextStyle: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
                dayTextStyle: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w400,
                ),
                weekdayLabels: [
                  'sun',
                  'mon',
                  'tue',
                  'wed',
                  'thu',
                  'fri',
                  'sat'
                ],
                dayBorderRadius: BorderRadius.circular(15.h),
              ),
              value: provider.selectedDatesFromCalendar ?? [],
              onValueChanged: (dates) {
                provider.selectedDatesFromCalendar = dates;
              },
            ),
          );
        },
      ),
    );
  }
}
