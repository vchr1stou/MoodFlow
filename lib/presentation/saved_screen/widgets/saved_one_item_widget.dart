import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/saved_one_item_model.dart';

// ignore_for_file: must_be_immutable
class SavedOneItemWidget extends StatelessWidget {
  SavedOneItemWidget(
    this.savedOneItemModelObj, {
    Key? key,
  }) : super(key: key);

  final SavedOneItemModel savedOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outline6.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgAnyoneButYou1176x312,
                  height: 90.h,
                  width: 160.h,
                  radius: BorderRadius.circular(16.h),
                  margin: EdgeInsets.only(left: 4.h),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              savedOneItemModelObj.messagelarge ?? "",
                              style: CustomTextStyles.titleSmallRobotoOnPrimary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              savedOneItemModelObj.messagelarge1 ?? "",
                              style:
                                  CustomTextStyles.labelLargeRobotoOnPrimary13,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: savedOneItemModelObj.italian ?? "",
                        height: 18.h,
                        width: 14.h,
                        alignment: Alignment.bottomCenter,
                        margin: EdgeInsets.only(bottom: 8.h, left: 10.h),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
