import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillGreen => ElevatedButton.styleFrom(
        backgroundColor: appTheme.green50001,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillPrimary => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get fillPrimaryTL14 => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  // Gradient button style
  static BoxDecoration get gradientPrimaryToPrimaryDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(20.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 1),
          end: Alignment(0.5, 0),
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0),
          ],
        ),
      );

  static BoxDecoration get gradientPrimaryToPrimaryTL12Decoration =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(12.h),
        gradient: LinearGradient(
          begin: Alignment(0.5, 1),
          end: Alignment(0.5, 0),
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0),
          ],
        ),
      );

  // Outline button style
  static ButtonStyle get outline => ElevatedButton.styleFrom(
        backgroundColor: appTheme.orange50099,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.h),
        ),
        elevation: 0,
        padding: EdgeInsets.zero,
      );

  static ButtonStyle get outlineBlack => ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.h),
        ),
        shadowColor: appTheme.black900.withValues(alpha: 0.25),
        elevation: 4,
        padding: EdgeInsets.zero,
      );

  static BoxDecoration get outlineTL14Decoration => BoxDecoration(
        color: appTheme.gray6007f,
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
      );

  static BoxDecoration get outlineTL141Decoration => BoxDecoration(
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
      );

  static BoxDecoration get outlineTL18Decoration => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18.h),
        border: GradientBoxBorder(
          width: 0.h,
          gradient: LinearGradient(
            begin: Alignment(0.08, 0),
            end: Alignment(0.15, 1),
            colors: [
              theme.colorScheme.onPrimary.withValues(alpha: 0.4),
              theme.colorScheme.onPrimary.withValues(alpha: 0.1),
            ],
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 2),
          )
        ],
      );

  static BoxDecoration get outlineTL24Decoration => BoxDecoration(
        color: appTheme.gray6004c,
        borderRadius: BorderRadius.circular(24.h),
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

  static BoxDecoration get outlineTL241Decoration => BoxDecoration(
        color: appTheme.gray6007f,
        borderRadius: BorderRadius.circular(24.h),
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
      );

  static BoxDecoration get outlineTL26Decoration => BoxDecoration(
        color: appTheme.gray5003f,
        borderRadius: BorderRadius.circular(26.h),
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

  // text button style
  static ButtonStyle get none => ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(0),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
        side: MaterialStateProperty.all<BorderSide>(
          BorderSide(color: Colors.transparent),
        ),
      );

  static BoxDecoration get outlineDecoration => BoxDecoration(
        color: appTheme.gray70019,
        borderRadius: BorderRadiusStyle.circleBorder22,
        border: Border.all(
          color: appTheme.gray70019,
          width: 1.h,
        ),
      );
}
