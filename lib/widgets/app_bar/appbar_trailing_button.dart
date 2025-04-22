import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../custom_drop_down.dart';

class AppbarTrailingButton extends StatelessWidget {
  AppbarTrailingButton({
    Key? key,
    this.onTap,
    this.margin,
  }) : super(key: key);

  final Function? onTap;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap: () {
          onTap?.call();
        },
        child: CustomElevatedButton(
          height: 26.h,
          width: 48.h,
          text: "lbl_7".tr,
          leftIcon: Container(
            margin: EdgeInsets.only(right: 10.h),
            child: CustomImageView(
              imagePath: ImageConstant.imgFlamefill2,
              height: 22.h,
              width: 16.h,
              fit: BoxFit.contain,
            ),
          ),
          buttonStyle: CustomButtonStyles.outline,
          buttonTextStyle: CustomTextStyles.titleMediumBold16,
          hasBlurBackground: true,
        ),
      ),
    );
  }
}
