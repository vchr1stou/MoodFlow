import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/app_bar/appbar_trailing_button_one.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_text_form_field.dart';
import 'models/ai_model.dart';
import 'provider/ai_provider.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({Key? key})
      : super(
          key: key,
        );

  @override
  AiScreenState createState() => AiScreenState();
  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AiProvider(),
      child: AiScreen(),
    );
  }
}

class AiScreenState extends State<AiScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray6004c,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 830.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _buildColumnsearchfie(context),
                  _buildStackhelp(context),
                  CustomImageView(
                    imagePath: ImageConstant.imgSirianimationshakyphone15pro,
                    height: 830.h,
                    width: double.maxFinite,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildColumnsearchfie(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4,
            sigmaY: 4,
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 14.h,
              vertical: 56.h,
            ),
            decoration: AppDecoration.gradientBlackToGray,
            child: Column(
              spacing: 14,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 18.h),
                Selector<AiProvider, TextEditingController?>(
                  selector: (context, provider) =>
                      provider.searchfieldoneController,
                  builder: (context, searchfieldoneController, child) {
                    return CustomTextFormField(
                      controller: searchfieldoneController,
                      hintText: "lbl_ask_me_anything".tr,
                      textInputAction: TextInputAction.done,
                      prefix: Padding(
                        padding: EdgeInsets.only(
                          left: 14.57.h,
                          right: 30.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgMic,
                              height: 24.h,
                              width: 14.83.h,
                              margin: EdgeInsets.fromLTRB(
                                  14.57.h, 9.48999.h, 14.599998.h, 10.51001.h),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.imgHighlightFrame,
                              height: 44.h,
                              width: 8.h,
                            )
                          ],
                        ),
                      ),
                      prefixConstraints: BoxConstraints(
                        maxHeight: 44.h,
                      ),
                      suffix: Container(
                        padding: EdgeInsets.all(10.h),
                        margin: EdgeInsets.only(left: 30.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.h,
                          ),
                          gradient: LinearGradient(
                            begin: Alignment(0.5, 1),
                            end: Alignment(0.5, 0),
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(
                                alpha: 0,
                              )
                            ],
                          ),
                        ),
                        child: CustomImageView(
                          imagePath: ImageConstant.imgPaperplanefill1,
                          height: 22.h,
                          width: 22.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      suffixConstraints: BoxConstraints(
                        maxHeight: 44.h,
                      ),
                    );
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.h,
                    vertical: 4.h,
                  ),
                  decoration: AppDecoration.viewsRecessedMaterialView.copyWith(
                    borderRadius: BorderRadiusStyle.roundedBorder24,
                  ),
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgHouseFill1Pink100,
                        height: 14.h,
                        width: 18.h,
                        margin: EdgeInsets.only(left: 12.h),
                      ),
                      Container(
                        width: 40.h,
                        margin: EdgeInsets.only(left: 2.h),
                        child: Text(
                          "lbl_home".tr,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.labelLargePink100,
                        ),
                      ),
                      Spacer(),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.18,
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 0.5.h,
                          ),
                          borderRadius: BorderRadiusStyle.circleBorder18,
                        ),
                        child: Container(
                          height: 36.h,
                          width: 120.h,
                          decoration: AppDecoration.outline1.copyWith(
                            borderRadius: BorderRadiusStyle.circleBorder18,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CustomImageView(
                                imagePath: ImageConstant.imgImage3,
                                height: 36.h,
                                width: double.maxFinite,
                              ),
                              CustomImageView(
                                imagePath: ImageConstant.imgBlurS36x118,
                                height: 36.h,
                                width: double.maxFinite,
                              )
                            ],
                          ),
                        ),
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgThumbsUpPink100,
                        height: 16.h,
                        width: 18.h,
                        margin: EdgeInsets.only(left: 20.h),
                      ),
                      Container(
                        width: 66.h,
                        margin: EdgeInsets.only(left: 2.h),
                        child: Text(
                          "lbl_little_lifts".tr,
                          overflow: TextOverflow.ellipsis,
                          style: CustomTextStyles.labelLargeOnPrimary13,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildStackhelp(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 162.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4,
                  sigmaY: 4,
                ),
                child: Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: AppDecoration.outline2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomAppBar(
                        height: 26.h,
                        actions: [
                          AppbarTrailingButtonOne(
                            margin: EdgeInsets.only(right: 27.h),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "msg_how_are_you_feeling2".tr,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.headlineLargeSFPro.copyWith(
                  height: 1.19,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
