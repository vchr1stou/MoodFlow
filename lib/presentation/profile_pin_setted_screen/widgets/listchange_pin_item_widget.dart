import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../models/listchange_pin_item_model.dart';

// ignore_for_file: must_be_immutable
class ListchangePinItemWidget extends StatelessWidget {
  ListchangePinItemWidget(
    this.listchangePinItemModelObj, {
    Key? key,
  }) : super(key: key);

  ListchangePinItemModel listchangePinItemModelObj;

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
              horizontal: 28.h,
              vertical: 16.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomImageView(
                  imagePath: listchangePinItemModelObj.changePinOne!,
                  height: 24.h,
                  width: 12.h,
                  margin: EdgeInsets.only(top: 2.h),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(
                    listchangePinItemModelObj.changepin!,
                    style: CustomTextStyles.titleSmallRoboto,
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
