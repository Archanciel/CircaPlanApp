import 'package:flutter/material.dart';

mixin ScreenMixin {
  /// This mixin class contains UI parameters used by all the Circa
  /// application screens. Since it is not possible to define a
  /// base class for the statefull widgets, using a mixin class
  /// to add those common instance variables to the statefull 
  /// widgets solves the problem.
  final Color appLabelColor = Colors.yellow.shade300;
  final Color appTextAndIconColor = Colors.white;
  final FontWeight appTextFontWeight = FontWeight.normal;
  final double appTextFontSize = 20;
}
