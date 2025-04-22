import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../../widgets/custom_drop_down.dart';
import '../models/listmum_one_item_model.dart';

// ignore_for_file: must_be_immutable
class ListmumOneItemWidget extends StatelessWidget {
  ListmumOneItemWidget(
    this.listmumOneItemModelObj, {
    Key? key,
  }) : super(key: key);

  final ListmumOneItemModel listmumOneItemModelObj;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outline7.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder32,
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 68, sigmaY: 68),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                _buildCall(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Call button widget
  Widget _buildCall(BuildContext context) {
    return CustomElevatedButton(
      height: 30.h,
      width: 68.h,
      text: "lbl_call".tr,
      margin: EdgeInsets.only(bottom: 2.h),
      leftIcon: Padding(
        padding: EdgeInsets.only(right: 4.h),
        child: CustomImageView(
          imagePath: ImageConstant.imgPhonefill1,
          height: 10.h,
          width: 10.h,
          fit: BoxFit.contain,
        ),
      ),
      buttonStyle: CustomButtonStyles.fillGreen,
      buttonTextStyle: CustomTextStyles.labelLarge13,
      alignment: Alignment.bottomCenter,
    );
  }
}
