import 'package:flutter/material.dart';

extension ResponsiveContext on BuildContext {
  /// The total width of the device screen.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// The total height of the device screen.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Returns a responsive width value based on a percentage of the screen width.
  double w(double percent) => screenWidth * (percent / 100);

  /// Returns a responsive height value based on a percentage of the screen height.
  double h(double percent) => screenHeight * (percent / 100);
}
