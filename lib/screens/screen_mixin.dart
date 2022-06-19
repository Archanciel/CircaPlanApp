import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  final DateFormat englishDateTimeFormat = DateFormat("yyyy-MM-dd HH:mm");
  final DateFormat frenchDateTimeFormat = DateFormat("dd-MM-yyyy HH:mm");
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
          style: const TextStyle(
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

  /// Extract date time string's from the passed transfer data map and return
  /// them in a list sorted with most recent first or last according to the
  /// mostRecentFirst bool paraneter.
  List<String> buildSortedAppDateTimeStrList(
      {required Map<String, dynamic> transferDataMap,
      required bool mostRecentFirst}) {
    final DateTime twoThousandDateTime = DateTime(2000);
    List<String> appDateTimeStrList = [];
    List<DateTime> appDateTimeList = [];

    for (var value in transferDataMap.values) {
      if (value is String && isDateTimeStrValid(value)) {
        DateTime? dateTime = parseDateTime(value);

        if (dateTime == null) {
          continue;
        }

        if (dateTime.isBefore(twoThousandDateTime)) {
          // the case is the parsed date time string was obtained from a
          // DatePickerField
          dateTime = englishDateTimeFormat.parse(value);
        }

        addDateTimeIfNotExist(appDateTimeList, dateTime);
      } else if (value is List<String> &&
          value.isNotEmpty &&
          isDateTimeStrValid(value.first)) {
        // adding to the DateTime list the first date time value of the sleep
        // and wake-up history list
        DateTime? dateTime = parseDateTime(value.first);

        if (dateTime == null) {
          continue;
        }

        addDateTimeIfNotExist(appDateTimeList, dateTime);
      }
    }

    // now sorting the DateTime list

    if (mostRecentFirst) {
      appDateTimeList.sort((a, b) =>
          b.millisecondsSinceEpoch.compareTo(a.millisecondsSinceEpoch));
    } else {
      appDateTimeList.sort((a, b) =>
          a.millisecondsSinceEpoch.compareTo(b.millisecondsSinceEpoch));
    }

    // returning a list of sorted date time string's

    return appDateTimeList.map((e) => frenchDateTimeFormat.format(e)).toList();
  }

  bool isDateTimeStrValid(String dateTimeStr) {
    /// Returns true if the passed dateTimeStr is either in french format
    /// (02-11-2022 03:55) or in english format (2022-11-21 09:34). Else,
    /// returns false.
    final RegExp regExpFrenchYYYYDateTime =
        RegExp(r'^(\d+-\d+-\d{4})\s(\d+:\d{2})');
    final RegExp regExpEnglishYYYYDateTime =
        RegExp(r'^(\d{4}-\d+-\d+)\s(\d+:\d{2})');

    RegExpMatch? match = regExpFrenchYYYYDateTime.firstMatch(dateTimeStr);

    if (match != null && match.groupCount == 2) {
      return true;
    } else {
      match = regExpEnglishYYYYDateTime.firstMatch(dateTimeStr);
      if (match != null && match.groupCount == 2) {
        return true;
      }
    }

    return false;
  }

  DateTime? parseDateTime(String dateTimeStr) {
    /// Returns a DateTime instance or null if parsing the dateTimeStr throws
    /// a FormatException
    DateTime dateTime;

    try {
      dateTime = frenchDateTimeFormat.parse(dateTimeStr);
    } on FormatException catch (_) {
      return null;
    }

    return dateTime;
  }

  void addDateTimeIfNotExist(
      List<DateTime> appDateTimeList, DateTime dateTime) {
    if (!appDateTimeList.contains(dateTime)) {
      // avoid inserting several same DateTime values
      appDateTimeList.add(dateTime);
    }
  }
}
