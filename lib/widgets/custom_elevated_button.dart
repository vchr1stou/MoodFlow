import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../core/app_export.dart';
import '../theme/custom_button_style.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton({
    Key? key,
    this.decoration,
    this.hasBlurBackground,
    this.leftIcon,
    this.rightIcon,
    EdgeInsets? margin,
    VoidCallback? onPressed,
    ButtonStyle? buttonStyle,
    Alignment? alignment,
    TextStyle? buttonTextStyle,
    bool? isDisabled,
    double? height,
    double? width,
    required String text,
  }) : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );

  final BoxDecoration? decoration;
  final bool? hasBlurBackground;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget,
          )
        : buildElevatedButtonWidget;
  }

  Widget get buildElevatedButtonWidget => Container(
        height: this.height ?? 48.h,
        width: this.width ?? double.maxFinite,
        margin: margin,
        decoration:
            decoration ?? CustomButtonStyles.gradientPrimaryToPrimaryDecoration,
        child: ClipRRect(
          borderRadius:
              (buttonStyle?.shape?.resolve({}) as RoundedRectangleBorder?)
                      ?.borderRadius ??
                  BorderRadius.circular(12.h),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: hasBlurBackground ?? false ? 4.h : 0,
              sigmaY: hasBlurBackground ?? false ? 4.h : 0,
            ),
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: isDisabled ?? false ? null : onPressed ?? () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  leftIcon ?? const SizedBox.shrink(),
                  Text(
                    text,
                    style: buttonTextStyle ??
                        CustomTextStyles.labelLargeRobotoOnPrimaryBold13_1,
                  ),
                  rightIcon ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      );
}
