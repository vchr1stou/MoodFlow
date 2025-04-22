import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/history_filled_item_model.dart';

// ignore_for_file: must_be_immutable
class HistoryFilledItemWidget extends StatelessWidget {
  HistoryFilledItemWidget(
    this.historyFilledItemModelObj, {
    Key? key,
  }) : super(key: key);

  HistoryFilledItemModel historyFilledItemModelObj;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: AppDecoration.gradientBlackToGray,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.maxFinite,
                margin: EdgeInsets.only(left: 4.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 12.h,
                ),
                decoration: AppDecoration.windowsGlass.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder32,
                ),
                child: Column(
                  spacing: 2,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  historyFilledItemModelObj.time!,
                                  style: theme.textTheme.titleSmall,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        historyFilledItemModelObj.bright!,
                                        style: CustomTextStyles
                                            .titleMediumSFProOnPrimaryBold,
                                      ),
                                    ),
                                    CustomImageView(
                                      imagePath: ImageConstant.img42x30,
                                      height: 26.h,
                                      width: 20.h,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Padding(
                                  padding: EdgeInsets.only(right: 4.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgGroup31Onprimary,
                                        height: 26.h,
                                        width: 26.h,
                                      ),
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgGroup39Onprimary,
                                        height: 26.h,
                                        width: 26.h,
                                      ),
                                      CustomImageView(
                                        imagePath:
                                            ImageConstant.imgGroup34Onprimary,
                                        height: 26.h,
                                        width: 26.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Column(
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 38.h),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CustomImageView(
                                          imagePath: ImageConstant.imgImg,
                                          height: 40.h,
                                          width: 40.h,
                                          radius: BorderRadius.circular(12.h),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgImg40x40,
                                          height: 40.h,
                                          width: 40.h,
                                          radius: BorderRadius.circular(12.h),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.maxFinite,
                                    margin: EdgeInsets.only(left: 4.h),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 26.h,
                                            margin:
                                                EdgeInsets.only(bottom: 2.h),
                                            decoration: AppDecoration
                                                .fillOnPrimary
                                                .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .roundedBorder14,
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.img271,
                                                  height: 20.h,
                                                  width: 22.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            height: 26.h,
                                            margin: EdgeInsets.only(
                                              left: 4.h,
                                              bottom: 2.h,
                                            ),
                                            decoration: AppDecoration
                                                .fillOnPrimary
                                                .copyWith(
                                              borderRadius: BorderRadiusStyle
                                                  .roundedBorder14,
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.img275,
                                                  height: 24.h,
                                                  width: 26.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgImg1,
                                          height: 40.h,
                                          width: 40.h,
                                          radius: BorderRadius.circular(12.h),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(left: 28.h),
                                        ),
                                        CustomImageView(
                                          imagePath: ImageConstant.imgImg2,
                                          height: 40.h,
                                          width: 40.h,
                                          radius: BorderRadius.circular(12.h),
                                          alignment: Alignment.center,
                                        ),
                                        CustomImageView(
                                          imagePath:
                                              ImageConstant.imgArrowRight,
                                          height: 22.h,
                                          width: 20.h,
                                          margin: EdgeInsets.only(left: 18.h),
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
                    SizedBox(
                      width: 208.h,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "lbl_playful2".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                            TextSpan(
                              text: "msg_secure_confident".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: 188.h,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "lbl_lonely2".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                            TextSpan(
                              text: "msg_numb_worried".tr,
                              style: theme.textTheme.labelLarge,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Row(
                        children: [
                          CustomImageView(
                            imagePath: ImageConstant.imgSettingsOnprimary,
                            height: 16.h,
                            width: 16.h,
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(left: 2.h),
                              child: Text(
                                historyFilledItemModelObj.partyintheu!,
                                style: theme.textTheme.labelSmall,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
