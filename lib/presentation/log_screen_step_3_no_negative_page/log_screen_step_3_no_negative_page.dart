import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_outlined_button.dart';
import 'models/log_screen_step_3_no_negative_model.dart';
import 'provider/log_screen_step_3_no_negative_provider.dart'; // ignore_for_file: must_be_immutable
import 'package:easy_localization/easy_localization.dart';

class LogScreenStep3NoNegativePage extends StatefulWidget {
  const LogScreenStep3NoNegativePage({Key? key})
      : super(
          key: key,
        );

  @override
  LogScreenStep3NoNegativePageState createState() =>
      LogScreenStep3NoNegativePageState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogScreenStep3NoNegativeProvider(),
      child: LogScreenStep3NoNegativePage(),
    );
  }
}

class LogScreenStep3NoNegativePageState
    extends State<LogScreenStep3NoNegativePage>
    with AutomaticKeepAliveClientMixin<LogScreenStep3NoNegativePage> {
  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.maxFinite,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 32.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
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
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder32,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "msg_no_negative_feelings".tr(),
                                      style: CustomTextStyles
                                          .titleMediumSFProSemiBold,
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
                          text: "lbl_next".tr(),
                          margin: EdgeInsets.only(right: 6.h),
                          buttonStyle: CustomButtonStyles.none,
                          decoration: CustomButtonStyles.outlineTL18Decoration,
                          buttonTextStyle: CustomTextStyles.titleSmallSemiBold,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
