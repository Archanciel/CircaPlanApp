import 'package:flutter/material.dart';

mixin ScreenMixin {
  /// This mixin class contains UI parameters used by all the Circa
  /// application screens. Since it is not possible to define a
  /// base class for the statefull widgets, using a mixin class
  /// to add those common instance variables to the statefull
  /// widgets solves the problem.
  static const String appTitle = 'Circadian Calculator';
  final Color appLabelColor = Colors.yellow.shade300;
  final Color appTextAndIconColor = Colors.white;
  static const FontWeight appTextFontWeight = FontWeight.normal;
  static const double appTextFontSize = 20;
  static const double appDrawerTextFontSize = 18;
  static const double appDrawerWidthProportion = 0.92;
  static const double appDrawerHeaderHeight = 80;
  static const String appDrawerHeaderText = ScreenMixin.appTitle;
  static const FontWeight appDrawerFontWeight = FontWeight.bold;
  static const String addDurationToDateTimeTitle = 'Add Duration To Date Time';
  static const String dateTimeDiffDurationTitle = 'Date Time Difference Duration';
  static const String calculateSleepDurationTitle = 'Calculate Sleep Duration';
}
