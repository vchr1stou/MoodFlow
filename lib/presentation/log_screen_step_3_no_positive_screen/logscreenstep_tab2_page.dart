import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/logscreenstep_tab2_model.dart';
import 'provider/log_screen_step_3_no_positive_provider.dart';

class LogscreenstepTab2Page extends StatefulWidget {
  const LogscreenstepTab2Page({Key? key})
      : super(
          key: key,
        );

  @override
  LogscreenstepTab2PageState createState() => LogscreenstepTab2PageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep3NoPositiveProvider(),
      child: LogscreenstepTab2Page(),
    );
  }
}

class LogscreenstepTab2PageState extends State<LogscreenstepTab2Page> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.h,
        vertical: 32.h,
      ),
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
                                    appTheme.black900.withValues(
                                      alpha: 0.1,
                                    ),
                                    appTheme.gray70019
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(horizontal: 8.h),
                            padding: EdgeInsets.symmetric(vertical: 206.h),
                            decoration: AppDecoration.windowsGlass.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder32,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "msg_no_positive_feelings".tr,
                                  style:
                                      CustomTextStyles.titleMediumSFProSemiBold,
                                ),
                                SizedBox(height: 28.h)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomOutlinedButton(
                      height: 36.h,
                      width: 118.h,
                      text: "lbl_next".tr,
                      margin: EdgeInsets.only(right: 6.h),
                      buttonStyle: CustomButtonStyles.none,
                      decoration: CustomButtonStyles.outlineTL18Decoration,
                      buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
