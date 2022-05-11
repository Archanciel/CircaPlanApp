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
  final MaterialStateProperty<Color?> appElevatedButtonBackgroundColor =
      MaterialStateProperty.all(Colors.blue.shade900);
  final MaterialStateProperty<RoundedRectangleBorder>
      appElevatedButtonRoundedShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)));
  static const FontWeight appTextFontWeight = FontWeight.normal;
  static const double appTextFontSize = 20;
  static const double appDrawerTextFontSize = 18;
  static const double appDrawerWidthProportion = 0.92;
  static const double appDrawerHeaderHeight = 80;
  static const String appDrawerHeaderText = ScreenMixin.appTitle;
  static const FontWeight appDrawerFontWeight = FontWeight.bold;
  static const String addDurationToDateTimeTitle = 'Add Duration To Date Time';
  static const String dateTimeDiffDurationTitle =
      'Date Time Difference Duration';
  static const String calculateSleepDurationTitle = 'Calculate Sleep Duration';

  Map<String, dynamic> getUpdatedTransferDataMap() {
    /// Returns the transferDataMap after having updated the map with the
    /// up to date values of the data specific to the current screen.
    throw UnimplementedError('getUpdatedTransferDataMap() not implemented');
  }
}