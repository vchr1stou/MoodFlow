import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../core/app_export.dart';

extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(36.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 8),
          )
        ],
      );

  static BoxDecoration get outlineBlackTL14 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(14.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.25),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 4),
          )
        ],
      );

  static BoxDecoration get fillPrimaryTL28 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(28.h),
      );

  static BoxDecoration get fillPrimaryTL18 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18.h),
      );

  static BoxDecoration get outline => BoxDecoration(
        color: appTheme.gray6004c,
        borderRadius: BorderRadius.circular(14.h),
        border: GradientBoxBorder(
          width: 1.h,
          gradient: LinearGradient(
            begin: Alignment(0.07, 0),
            end: Alignment(0.13, 1),
            colors: [
              theme.colorScheme.onPrimary.withValues(alpha: 0.4),
              theme.colorScheme.onPrimary.withValues(alpha: 0.1),
            ],
          ),
        ),
        boxShadow: [
          BoxShadow(
            spreadRadius: 2.h,
            blurRadius: 2.h,
          )
        ],
      );

  static BoxDecoration get fillPrimaryTL22 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(22.h),
      );

  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20.h),
      );

  static BoxDecoration get none => BoxDecoration();
}

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.height,
    this.width,
    this.decoration,
    this.padding,
    this.onTap,
    this.child,
  }) : super(key: key);

  final Alignment? alignment;
  final double? height;
  final double? width;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => SizedBox(
        height: height ?? 0,
        width: width ?? 0,
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14.h),
              ),
          child: IconButton(
            padding: padding ?? EdgeInsets.zero,
            onPressed: onTap,
            icon: child ?? Container(),
          ),
        ),
      );
}

class CustomFloatingTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final bool obscureText;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;

  const CustomFloatingTextField({
    Key? key,
    this.controller,
    this.labelText,
    this.labelStyle,
    this.hintText,
    this.textInputAction,
    this.textInputType,
    this.obscureText = false,
    this.contentPadding,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: labelStyle,
        hintText: hintText,
        contentPadding: contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textInputAction: textInputAction,
      keyboardType: textInputType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}
