import 'package:flutter/material.dart';
import 'dart:math';

/// Usage:
/// ```dart
/// final res = Responsive.of(context);
/// double width20 = res.width(20);   // 20 px (design) -> relative to device width
/// double height10 = res.height(10); // 10 px (design) -> relative to device height
/// double font16 = res.fontSize(16); // 16 px size, scaling with device pixel ratio
/// ```
/// Or as a widget wrapper:
/// ```dart
/// ResponsiveBuilder(builder: (context, res) => ...)
/// ```



class Responsive {
  final BuildContext context;

  // Base design size (e.g. from Figma/XD)
  static const double baseWidth = 360.0;
  static const double baseHeight = 690.0;

  Responsive(this.context);

  Size get size => MediaQuery.of(context).size;
  double get pixelRatio => MediaQuery.of(context).devicePixelRatio;
  TextScaler get textScale => MediaQuery.of(context).textScaler;
  Orientation get orientation => MediaQuery.of(context).orientation;

  /// Width scaled based on design width
  double width(double w) => size.width * (w / baseWidth);

  /// Height scaled based on design height
  double height(double h) => size.height * (h / baseHeight);

  /// Font size scaled based on width and text scale factor
  double fontSize(double fs) =>
      textScale.scale(fs * (size.width / baseWidth));




  /// Minimum radius based on width
  double radiusWidth(double percentOfWidth) =>
      size.width * (percentOfWidth / 100);

  /// Radius based on screen height percentage
  double radiusHeight(double percentOfHeight) =>
      size.height * (percentOfHeight / 100);




  double radius (double d) =>
      d * sqrt(pow(size.width / baseWidth, 2) + pow(size.height / baseHeight, 2)) / sqrt(2);

  /// Detect if device is a tablet
  bool get isTablet => size.shortestSide >= 600;




  /// Convenient static accessor
  static Responsive of(BuildContext context) => Responsive(context);
}




/// Optionally, you can use this for widget-based access:
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Responsive res) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return builder(context, Responsive(context));
  }
}
