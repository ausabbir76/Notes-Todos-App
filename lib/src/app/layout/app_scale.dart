import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class AppScale {
  const AppScale._();

  static const Size designSize = Size(412, 915);
  static double _scale = 1;

  static double get value => _scale;

  static void update(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final widthScale = size.width / designSize.width;
    final heightScale = size.height / designSize.height;
    _scale = math.min(widthScale, heightScale).clamp(0.85, 1.0).toDouble();
  }

  static double size(double value) => value * _scale;

  static EdgeInsets edgeInsets(EdgeInsets value) {
    return EdgeInsets.fromLTRB(
      size(value.left),
      size(value.top),
      size(value.right),
      size(value.bottom),
    );
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: size(left),
      top: size(top),
      right: size(right),
      bottom: size(bottom),
    );
  }

  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: size(horizontal),
      vertical: size(vertical),
    );
  }
}
