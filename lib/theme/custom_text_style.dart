import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_export.dart';
import '../core/utils/color_constant.dart';
import '../core/utils/size_utils.dart';

extension on TextStyle {
  TextStyle get sFPro {
    return copyWith(
      fontFamily: 'SF Pro',
    );
  }

  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargeSFPro =>
      theme.textTheme.bodyLarge!.sFPro.copyWith(
        fontSize: 16.fSize,
      );
  static TextStyle get bodySmallOnPrimary =>
      theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 12.fSize,
      );

  // Display text style
  static TextStyle get displayMediumSFProGray700 =>
      theme.textTheme.displayMedium!.sFPro.copyWith(
        color: appTheme.gray700,
      );
  static TextStyle get displayMediumSemiBold =>
      theme.textTheme.displayMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get displayMediumWhiteA700 =>
      theme.textTheme.displayMedium!.copyWith(
        color: appTheme.whiteA700,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get displaySmallSFProOnPrimary =>
      theme.textTheme.displaySmall!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
      );

  // Headline text style
  static TextStyle get headlineLarge30 =>
      theme.textTheme.headlineLarge!.copyWith(
        fontSize: 30.fSize,
      );
  static TextStyle get headlineLargeSFPro =>
      theme.textTheme.headlineLarge!.sFPro.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get headlineLargeSFProOnPrimary =>
      theme.textTheme.headlineLarge!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 30.fSize,
      );
  static TextStyle get headlineMediumSFProOnPrimary =>
      theme.textTheme.headlineMedium!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 26.fSize,
      );
  static TextStyle get headlineSmall24 =>
      theme.textTheme.headlineSmall!.copyWith(
        fontSize: 24.fSize,
      );
  static TextStyle get headlineSmallOnPrimary =>
      theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get headlineSmallRobotoOnPrimary =>
      theme.textTheme.headlineSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get headlineSmallRobotoOnPrimarySemiBold =>
      theme.textTheme.headlineSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 24.fSize,
        fontWeight: FontWeight.w600,
      );

  // Label text style
  static TextStyle get labelLarge13 => theme.textTheme.labelLarge!.copyWith(
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeBold => theme.textTheme.labelLarge!.copyWith(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeGray10001 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray10001,
      );
  static TextStyle get labelLargeGray700 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray700,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeGray70013 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.gray700,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeOnPrimary =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeOnPrimary13 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.6,
        ),
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeOnPrimary13_1 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeOnPrimary13_2 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeOnPrimary_1 =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get labelLargePink100 =>
      theme.textTheme.labelLarge!.copyWith(
        color: appTheme.pink100,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeRoboto =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeRobotoGray100 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: appTheme.gray100,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeRobotoMedium => GoogleFonts.roboto(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface,
      );
  static TextStyle get labelLargeRobotoOnPrimary =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.9,
        ),
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelLargeRobotoOnPrimary13 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
      );
  static TextStyle get labelLargeRobotoOnPrimaryBold =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.9,
        ),
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeRobotoOnPrimaryBold13 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeRobotoOnPrimaryBold13_1 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeRobotoOnPrimaryBold_1 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get labelLargeRobotoOnPrimaryMedium =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelLargeRobotoOnPrimaryMedium13 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelLargeRobotoSecondaryContainer =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelLargeRobotoSecondaryContainerMedium =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: theme.colorScheme.secondaryContainer.withValues(
          alpha: 1,
        ),
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelLargeRobotoWhiteA700 =>
      theme.textTheme.labelLarge!.roboto.copyWith(
        color: appTheme.whiteA700,
      );
  static get labelLargeRoboto_1 => theme.textTheme.labelLarge!.roboto;
  static TextStyle get labelMediumGray700 =>
      theme.textTheme.labelMedium!.copyWith(
        color: appTheme.gray700,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumOnPrimary =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumOnPrimarySemiBold =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumOnPrimary_1 =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get labelMediumRoboto =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumRobotoMedium => GoogleFonts.roboto(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface,
      );
  static TextStyle get labelMediumRobotoOnPrimary =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 11.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumRobotoOnPrimary11 =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.8,
        ),
        fontSize: 11.fSize,
      );
  static TextStyle get labelMediumRobotoOnPrimary11_1 =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 11.fSize,
      );
  static TextStyle get labelMediumRobotoOnPrimaryMedium =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get labelMediumRobotoOnPrimarySemiBold => GoogleFonts.roboto(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      );
  static TextStyle get labelMediumRobotoOnPrimary_1 =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get labelMediumRobotoOnPrimary_2 =>
      theme.textTheme.labelMedium!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get labelMediumRobotoSemiBold => GoogleFonts.roboto(
        fontSize: 13.fSize,
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
      );
  static TextStyle get labelMediumSemiBold =>
      theme.textTheme.labelMedium!.copyWith(
        fontSize: 11.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumSemiBold_1 =>
      theme.textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelSmallRoboto =>
      theme.textTheme.labelSmall!.roboto.copyWith(
        fontSize: 9.fSize,
      );

  // Roboto text style
  static TextStyle get robotoOnPrimary => TextStyle(
        color: theme.colorScheme.onPrimary,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w600,
      ).roboto;
  static TextStyle get robotoOnPrimaryBold => TextStyle(
        color: theme.colorScheme.onPrimary,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w700,
      ).roboto;

  // Title text style
  static TextStyle get titleLargeRobotoOnPrimary =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeRobotoOnPrimarySemiBold =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 21.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeRobotoOnPrimarySemiBold23 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 23.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeRobotoOnPrimarySemiBold_1 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleLargeRobotoOnPrimary_1 =>
      theme.textTheme.titleLarge!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get titleMediumBold => theme.textTheme.titleMedium!.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumBold16 =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumBold18 =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumOnPrimary =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumOnPrimaryBold =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumSFPro =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumSFProBold =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumSFProGray700 =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        color: appTheme.gray700,
      );
  static TextStyle get titleMediumSFProOnPrimary =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.91,
        ),
        fontSize: 19.fSize,
      );
  static TextStyle get titleMediumSFProOnPrimaryBold =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 19.fSize,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumSFProOnPrimaryBold_1 =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontWeight: FontWeight.w700,
      );
  static TextStyle get titleMediumSFProOnPrimarySemiBold =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.96,
        ),
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumSFProSemiBold =>
      theme.textTheme.titleMedium!.sFPro.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumSecondaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.secondaryContainer.withValues(
          alpha: 1,
        ),
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumSemiBold =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 19.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumSemiBold16 =>
      theme.textTheme.titleMedium!.copyWith(
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumSemiBold_1 =>
      theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumWhiteA700 =>
      theme.textTheme.titleMedium!.copyWith(
        color: appTheme.whiteA700,
        fontSize: 16.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallBlack900 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.black900,
        fontSize: 14.fSize,
      );
  static TextStyle get titleSmallGray700 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray700,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallGray700_1 =>
      theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray700,
      );
  static get titleSmallRoboto => theme.textTheme.titleSmall!.roboto;
  static TextStyle get titleSmallRoboto14 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        fontSize: 14.fSize,
      );
  static TextStyle get titleSmallRoboto14_1 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        fontSize: 14.fSize,
      );
  static TextStyle get titleSmallRobotoOnPrimary =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallRobotoOnPrimary14 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 14.fSize,
      );
  static TextStyle get titleSmallRobotoOnPrimaryMedium =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get titleSmallRobotoOnPrimarySemiBold =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallRobotoOnPrimarySemiBold14 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallRobotoOnPrimarySemiBold_1 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary.withValues(
          alpha: 0.63,
        ),
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallRobotoOnPrimary_1 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get titleSmallRobotoOnPrimary_2 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static TextStyle get titleSmallRobotoSecondaryContainer =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: theme.colorScheme.secondaryContainer.withValues(
          alpha: 1,
        ),
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallRobotoWhiteA700 =>
      theme.textTheme.titleSmall!.roboto.copyWith(
        color: appTheme.whiteA700,
        fontSize: 14.fSize,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallSemiBold =>
      theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );

  static TextStyle get labelLargeRobotoOnPrimaryContainer => TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  static TextStyle get labelLargeRobotoGray800 => TextStyle(
        color: appTheme.gray800,
        fontSize: 13.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  static TextStyle get displayMediumOnPrimaryContainer => TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 45.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  static TextStyle get titleLargeRobotoOnPrimaryContainerSemiBold_1 =>
      TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 20.fSize,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      );
}
