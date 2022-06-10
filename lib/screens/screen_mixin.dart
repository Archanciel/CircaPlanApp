import 'package:flutter/material.dart';

mixin ScreenMixin {
  /// This mixin class contains UI parameters used by all the Circa
  /// application screens. Since it is not possible to define a
  /// base class for the statefull widgets, using a mixin class
  /// to add those common instance variables to the statefull
  /// widgets solves the problem.

  static Color APP_DARK_BLUE_COLOR = Colors.blue.shade900;
  static Color APP_LIGHT_BLUE_COLOR = Colors.blue;
  static Color APP_LIGHT_YELLOW_COLOR = Colors.yellow.shade300;
  static Color APP_LIGHTER_YELLOW_COLOR = Colors.yellow.shade200;
  static double app_computed_vertical_top_margin = 0;
  static const String APP_TITLE = 'Circadian Calculator';
  final Color appLabelColor = ScreenMixin.APP_LIGHT_YELLOW_COLOR;
  final Color appTextAndIconColor = Colors.white;
  final Color selectionColor = ScreenMixin.APP_DARK_BLUE_COLOR;
  final MaterialStateProperty<Color?> appElevatedButtonBackgroundColor =
      MaterialStateProperty.all(ScreenMixin.APP_DARK_BLUE_COLOR);
  final MaterialStateProperty<RoundedRectangleBorder>
      appElevatedButtonRoundedShape =
      MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)));
  static const Color APP_TEXT_AND_ICON_COLOR = Colors.white;
  static const FontWeight APP_TEXT_FONT_WEIGHT = FontWeight.normal;
  static const double APP_LABEL_TO_TEXT_DISTANCE = 5;
  static const double APP_TEXT_FONT_SIZE = 18;
  static const double APP_VERTICAL_TOP_MARGIN_PROPORTION = 0.03;
  static const String APP_DURATION_TO_DATE_TIME_TITLE =
      'Add Duration To Date Time';
  static const String DATE_TIME_DIFF_DURATION_TITLE =
      'Date Time Difference Duration';
  static const String CALCULATR_SLEEP_DURATION_TITLE =
      'Calculate Sleep Duration';
  static const String TIME_CALCULATOR_TITLE = 'Time Calculator';
  static const double APP_VERTICAL_TOP_RESET_BUTTON_MARGIN_PROPORTION = 0.755;

  static void setAppVerticalTopMargin(double screenHeight) {
    app_computed_vertical_top_margin =
        screenHeight * APP_VERTICAL_TOP_MARGIN_PROPORTION;
  }

  void openWarningDialog(BuildContext context, String message) {
    /// Located in ScreenMixin in order to be usable in any screen.
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('WARNING'),
        content: Text(
          message,
          style: TextStyle(
            fontSize: ScreenMixin.APP_TEXT_FONT_SIZE,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  List<String> buildAppDateTimeStrList(
      {required Map<String, dynamic> transferDataMap}) {
    List<String> appDateTimeStrList = [];

    return appDateTimeStrList;
  }
  
  bool isDateTimeStr(String str) {
    return str.contains('-');
  }
}
