import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listmum_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ListmumOneItemWidget extends StatelessWidget {
  ListmumOneItemWidget(
    this.listmumOneItemModelObj, {
    Key? key,
  }) : super(key: key);

  ListmumOneItemModel listmumOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL30,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 68,
            sigmaY: 68,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 18.h,
              vertical: 10.h,
            ),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgIconsAvatar,
                  height: 38.h,
                  width: 38.h,
                  radius: BorderRadius.circular(18.h),
                ),
                SizedBox(width: 12.h),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listmumOneItemModelObj.mumTwo ?? "",
                        style: theme.textTheme.titleSmall,
                      ),
                      Text(
                        listmumOneItemModelObj.mobileNo ?? "",
                        style: CustomTextStyles.labelLargeGray70013,
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
