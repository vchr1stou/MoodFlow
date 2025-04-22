import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  // Blur decorations
  static BoxDecoration get blur => BoxDecoration(
        color: appTheme.pink900,
      );

  // Controls decorations
  static BoxDecoration get controlsIdle => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
      );

  // Fill decorations
  static BoxDecoration get fillBlueGray => BoxDecoration(
        color: appTheme.blueGray10072,
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray200,
      );
  static BoxDecoration get fillIndigo => BoxDecoration(
        color: appTheme.indigo50,
      );
  static BoxDecoration get fillOnPrimary => BoxDecoration(
        color: theme.colorScheme.onPrimary,
      );

  // For decorations
  static BoxDecoration get forBackgroundpinkyellowbggradient => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1, 0.41),
          end: Alignment(0, 1),
          colors: [appTheme.amber300, appTheme.pink300, appTheme.red400],
        ),
      );

  // Gradient decorations
  static BoxDecoration get gradientAmberToRed => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1, 0.41),
          end: Alignment(0, 1),
          colors: [appTheme.amber300, appTheme.pink300, appTheme.red400],
        ),
      );
  static BoxDecoration get gradientAmberToRed400 => BoxDecoration(
        color: appTheme.gray6004c,
        gradient: LinearGradient(
          begin: Alignment(1, 0.41),
          end: Alignment(0, 1),
          colors: [appTheme.amber300, appTheme.pink300, appTheme.red400],
        ),
      );
  static BoxDecoration get gradientAmberToRed4001 => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(1, 0.41),
          end: Alignment(0, 1),
          colors: [appTheme.amber300, appTheme.pink300, appTheme.red400],
        ),
      );
  static BoxDecoration get gradientBlackToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 0.53),
          colors: [
            appTheme.black900.withValues(alpha: 0.1),
            appTheme.gray70019
          ],
        ),
      );
  static BoxDecoration get gradientPrimaryToPrimary => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 1),
          end: Alignment(0.5, 0),
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0)
          ],
        ),
      );

  // Outline decorations
  static BoxDecoration get outline => BoxDecoration(
        color: appTheme.gray6004c,
      );
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.18),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(5, 0),
          )
        ],
      );
  static BoxDecoration get outline1 => BoxDecoration(
        color: appTheme.gray6004c,
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.25),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 4),
          )
        ],
      );
  static BoxDecoration get outline10 => BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.18),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 2),
          )
        ],
      );
  static BoxDecoration get outline11 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 2),
          )
        ],
      );
  static BoxDecoration get outline12 => BoxDecoration(
        color: appTheme.gray5019,
      );
  static BoxDecoration get outline13 => BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.18),
      );
  static BoxDecoration get outline14 => BoxDecoration(
        color: appTheme.gray4000a,
      );
  static BoxDecoration get outline2 => BoxDecoration(
        color: appTheme.pink800,
      );
  static BoxDecoration get outline3 => BoxDecoration(
        color: appTheme.red300,
      );
  static BoxDecoration get outline4 => BoxDecoration(
        color: appTheme.orange300,
      );
  static BoxDecoration get outline5 => BoxDecoration(
        color: appTheme.orange30001,
      );
  static BoxDecoration get outline6 => BoxDecoration(
        color: appTheme.gray6004c,
      );
  static BoxDecoration get outline7 => BoxDecoration();
  static BoxDecoration get outline8 => BoxDecoration(
        color: appTheme.gray5003f,
      );
  static BoxDecoration get outline9 => BoxDecoration(
        color: appTheme.gray40019,
      );

  // Text decorations
  static BoxDecoration get textPrimary => BoxDecoration();

  static BoxDecoration get viewsRecessedMaterialView => BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: appTheme.black900.withValues(alpha: 0.1),
          ),
          BoxShadow(
            color: appTheme.blueGray1007f,
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(1, 1.5),
          )
        ],
      );
  static BoxDecoration get viewsRegular => BoxDecoration(
        color: appTheme.blueGray10072,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.07),
            width: 1.h,
          ),
        ),
      );

  // Windows decorations
  static BoxDecoration get windowsGlass => BoxDecoration(
        color: appTheme.gray6004c,
      );
  static BoxDecoration get windowsGlassBlur => BoxDecoration(
        color: appTheme.gray6004c,
      );

  // Column decorations
  static BoxDecoration get column11 => BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConstant.imgSirianimationshakyphone15pro),
          fit: BoxFit.fill,
        ),
      );
  static BoxDecoration get column12 => BoxDecoration(
        color: appTheme.pink900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12.h),
      );
}

class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder18 => BorderRadius.circular(18.h);
  static BorderRadius get circleBorder76 => BorderRadius.circular(76.h);
  static BorderRadius get circleBorder8 => BorderRadius.circular(8.h);
  static BorderRadius get circleBorder88 => BorderRadius.circular(88.h);
  static BorderRadius get circleBorder22 => BorderRadius.circular(22.h);

  // Custom borders
  static BorderRadius get customBorderBL30 =>
      BorderRadius.vertical(bottom: Radius.circular(30.h));
  static BorderRadius get customBorderTL30 =>
      BorderRadius.vertical(top: Radius.circular(30.h));

  // Rounded borders
  static BorderRadius get roundedBorder14 => BorderRadius.circular(14.h);
  static BorderRadius get roundedBorder24 => BorderRadius.circular(24.h);
  static BorderRadius get roundedBorder28 => BorderRadius.circular(28.h);
  static BorderRadius get roundedBorder32 => BorderRadius.circular(32.h);
  static BorderRadius get roundedBorder36 => BorderRadius.circular(36.h);
  static BorderRadius get roundedBorder50 => BorderRadius.circular(50.h);
}
