import 'package:flutter/material.dart';
import '../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // The current app theme
  var _appTheme = PrefUtils().getThemeData();

  // A map of custom color themes supported by the app
  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  // A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'lightCode': ColorSchemes.lightCodeColorScheme
  };

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.lightCodeColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: appTheme.gray6007f,
          side: BorderSide(width: 1.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.h),
          ),
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
          ),
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          padding: EdgeInsets.zero,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        side: BorderSide(width: 1),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.onPrimary,
      ),
    );
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 17.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.gray70001,
          fontSize: 10.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 40.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        displaySmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 36.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 32.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 29.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 25.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 12.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 10.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
        labelSmall: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 8.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 20.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 17.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onPrimary.withValues(alpha: 0.96),
          fontSize: 15.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w700,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final lightCodeColorScheme = ColorScheme.light(
    primary: Color(0X235E5E5E),
    secondaryContainer: Color(0XE5484848),
    onPrimary: Color(0XFFFFFFFF),
    onPrimaryContainer: Color(0XFFFF0000),
  );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  // Amber
  Color get amber300 => Color(0XFFFBCB50);

  // Black
  Color get black900 => Color(0XFF000000);

  // BlueGray
  Color get blueGray10072 => Color(0X72D6D6D6);
  Color get blueGray1007f => Color(0X7FD0D0D0);
  Color get blueGray8001e => Color(0X1E333B4F);

  // Cyan
  Color get cyan400 => Color(0XFF1DB9C3);
  Color get cyan50 => Color(0XFFD4F6FF);

  // DeepOrange
  Color get deepOrangeA400 => Color(0XFFFF4015);

  // Gray
  Color get gray100 => Color(0XFFF3F3FF);
  Color get gray10001 => Color(0XFFF5F5F5);
  Color get gray200 => Color(0XFFE9E9EB);
  Color get gray300 => Color(0XFFE3E4E8);
  Color get gray400 => Color(0XFFC7C7C7);
  Color get gray4000a => Color(0X0ABBBBBB);
  Color get gray40019 => Color(0X19BEBEBE);
  Color get gray50 => Color(0XFFFAFAFF);
  Color get gray5003f => Color(0X3F959595);
  Color get gray5019 => Color(0X19F8F8F8);
  Color get gray6004c => Color(0X4C7F7F7F);
  Color get gray6007f => Color(0X7F7D7979);
  Color get gray700 => Color(0XFF545454);
  Color get gray70001 => Color(0XFF646464);
  Color get gray70019 => Color(0X19666666);
  Color get gray800 => Color(0xFF424242);

  // Green
  Color get green500 => Color(0XFF34C759);
  Color get green50001 => Color(0XFF32D74B);

  // Indigo
  Color get indigo50 => Color(0XFFE6E5EB);

  // Orange
  Color get orange300 => Color(0XFFFFBE5B);
  Color get orange30001 => Color(0XFFFFBC42);
  Color get orange400 => Color(0XFFFFA718);
  Color get orange50099 => Color(0X99FF9500);

  // Pink
  Color get pink100 => Color(0XFFE7C2CE);
  Color get pink300 => Color(0XFFD87297);
  Color get pink30001 => Color(0XFFF25D97);
  Color get pink800 => Color(0XFFA3444F);
  Color get pink900 => Color(0XFF8C2C2A);
  Color get pinkA100 => Color(0XFFF56FAD);

  // Purple
  Color get purple500 => Color(0XFFC32BAD);
  Color get purple700 => Color(0XFF7027A0);

  // Red
  Color get red100 => Color(0XFFFFD0DA);
  Color get red200 => Color(0XFFDF9D96);
  Color get red300 => Color(0XFFD78F5D);
  Color get red30001 => Color(0XFFDB6F84);
  Color get red400 => Color(0XFFE36658);

  // White
  Color get whiteA700 => Color(0XFFFFFEFE);
}
