import 'package:flutter/material.dart';

class ThemeHelper {
  static ThemeData get theme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          primary: Colors.amber,
          secondary: Colors.grey[700]!,
          background: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none,
            decorationColor: Colors.transparent,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.transparent,
          selectionHandleColor: Colors.transparent,
          cursorColor: Colors.transparent,
        ),
      );

  static Color get black900 => Colors.black;
  static Color get gray70019 => Colors.grey[700]!.withOpacity(0.1);
}
