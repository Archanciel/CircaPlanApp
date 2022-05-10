import 'package:flutter/material.dart';

mixin ScreenMixin {
  /// This mixin class contains UI parameters used by all the Circa
  /// application screens. Since it is not possible to define a
  /// base class for the statefull widgets, using a mixin class
  /// to add those common instance variables to the statefull
  /// widgets solves the problem.

  static double appVerticalTopMargin = 0;
  static const String appTitle = 'Circadian Calculator';
  final Color appLabelColor = Colors.yellow.shade300;
  final Color appTextAndIconColor = Colors.white;
  final MaterialStateProperty<Color?> appElevatedButtonBackgroundColor =
      MaterialStateProperty.all(Colors.blue.shade900);
  final MaterialStateProperty<RoundedRectangleBorder>
      appElevatedButtonRoundedShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)));
  static const FontWeight appTextFontWeight = FontWeight.normal;
  static const double appTextFontSize = 20;
  static const double appVerticalTopMarginProportion = 0.025;
  static const String addDurationToDateTimeTitle = 'Add Duration To Date Time';
  static const String dateTimeDiffDurationTitle =
      'Date Time Difference Duration';
  static const String calculateSleepDurationTitle = 'Calculate Sleep Duration';

  static void setAppVerticalTopMargin(double screenHeight) {
    appVerticalTopMargin = screenHeight * appVerticalTopMarginProportion;
  }
}
