import 'package:flutter/material.dart'; // These are the Viewport values of your Figma Design.

// These are used in the code as a reference to create your UI Responsively.
const num FIGMA_DESIGN_WIDTH = 393;
const num FIGMA_DESIGN_HEIGHT = 852;
const num FIGMA_DESIGN_STATUS_BAR = 0;

extension ResponsiveExtension on num {
  // Ensure _width doesn't throw error if width is not initialized
  double get _width =>
      SizeUtils.isInitialized ? SizeUtils.width : FIGMA_DESIGN_WIDTH.toDouble();
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);
  double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
  double get v => ((this *
          (SizeUtils.isInitialized
              ? SizeUtils.height
              : FIGMA_DESIGN_HEIGHT.toDouble())) /
      FIGMA_DESIGN_HEIGHT);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(this.toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

class Sizer extends StatelessWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);

  /// Builds the widget whenever the orientation changes.
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

// ignore_for_file: must_be_immutable
class SizeUtils {
  static late MediaQueryData _mediaQueryData;
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double horizontalBlockSize = 0.0;
  static double verticalBlockSize = 0.0;
  static double statusBarHeight = 0.0;
  static double bottomBarHeight = 0.0;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
  }

  static double get height => screenHeight;
  static double get width => screenWidth;

  static set height(double value) => screenHeight = value;
  static set width(double value) => screenWidth = value;

  /// Device's BoxConstraints
  static BoxConstraints boxConstraints = BoxConstraints();

  /// Device's Orientation
  static Orientation orientation = Orientation.portrait;

  /// Type of Device
  ///
  /// This can either be mobile or tablet
  static DeviceType deviceType = DeviceType.mobile;

  /// Flag to check if SizeUtils has been initialized
  static bool isInitialized = false;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;
    if (orientation == Orientation.portrait) {
      width =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
    isInitialized = true;
  }
}
