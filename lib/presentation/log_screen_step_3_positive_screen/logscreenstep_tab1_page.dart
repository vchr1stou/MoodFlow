import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/logscreenstep_tab1_model.dart';
import 'provider/log_screen_step_3_positive_provider.dart';

class LogscreenstepTab1Page extends StatefulWidget {
  const LogscreenstepTab1Page({Key? key}) : super(key: key);

  @override
  LogscreenstepTab1PageState createState() => LogscreenstepTab1PageState();

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LogScreenStep3PositiveProvider(),
      child: const LogscreenstepTab1Page(),
    );
  }
}

class LogscreenstepTab1PageState extends State<LogscreenstepTab1Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 32.h),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  spacing: 74,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 466.h,
                      width: double.maxFinite,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              height: 418.h,
                              width: 382.h,
                              margin: EdgeInsets.only(top: 4.h),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.5, 0),
                                  end: Alignment(0.5, 0.53),
                                  colors: [
                                    appTheme.black900.withValues(alpha: 0.1),
                                    appTheme.gray70019,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(horizontal: 8.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 36.h,
                              vertical: 22.h,
                            ),
                            decoration: AppDecoration.windowsGlass.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildRowlabelThree(
                                    context,
                                    labelThree: "lbl_confident".tr(),
                                    labelFour: "lbl_70".tr(),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  height: 28.h,
                                  width: 288.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14.h),
                                    boxShadow: [
                                      BoxShadow(
                                        color: appTheme.black900
                                            .withValues(alpha: 0.1),
                                      ),
                                      BoxShadow(
                                        color: appTheme.blueGray1007f,
                                        spreadRadius: 0,
                                        blurRadius: 4,
                                        offset: Offset(1, 1.5),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.h),
                                    child: LinearProgressIndicator(
                                      value: 0.64,
                                      backgroundColor: appTheme.blueGray1007f,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildRowlabelThree(
                                    context,
                                    labelThree: "lbl_proud".tr(),
                                    labelFour: "lbl_50".tr(),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Slider(
                                  value: 0.0,
                                  min: 0.0,
                                  max: 100.0,
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: 24.h),
                                SizedBox(
                                  width: double.maxFinite,
                                  child: _buildRowlabelThree(
                                    context,
                                    labelThree: "lbl_secure".tr(),
                                    labelFour: "lbl_302".tr(),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Slider(
                                  value: 0.0,
                                  min: 0.0,
                                  max: 100.0,
                                  onChanged: (value) {},
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 56.h,
                                      child: Text(
                                        "lbl_playful".tr(),
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles
                                            .titleMediumSFProOnPrimarySemiBold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 48.h,
                                      child: Text(
                                        "lbl_100".tr(),
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomTextStyles
                                            .titleMediumSFProOnPrimarySemiBold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Container(
                                  height: 28.h,
                                  width: 288.h,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onPrimary
                                        .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(14.h),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(14.h),
                                    child: LinearProgressIndicator(
                                      value: 1.0,
                                      backgroundColor: theme
                                          .colorScheme.onPrimary
                                          .withValues(alpha: 0.6),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          appTheme.blueGray1007f),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 116.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomOutlinedButton(
                      height: 36.h,
                      width: 118.h,
                      text: "lbl_next".tr(),
                      margin: EdgeInsets.only(right: 6.h),
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineTL18Decoration,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildRowlabelThree(
    BuildContext context, {
    required String labelThree,
    required String labelFour,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 48.h,
          child: Text(
            labelThree,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumSFProOnPrimarySemiBold.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.96),
            ),
          ),
        ),
        SizedBox(
          width: 38.h,
          child: Text(
            labelFour,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.titleMediumSFProOnPrimarySemiBold.copyWith(
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.96),
            ),
          ),
        ),
      ],
    );
  }
}
