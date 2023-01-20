import 'dart:io';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/utils/utility.dart';

class DateTimeComputer {
  static final String localName = Platform.localeName;
  static final DateFormat localDateTimeFormat =
      DateFormat('dd-MM-yyyy HH:mm', localName);

  /// Add the positive or negative durations contained as Strings in the passed
  /// posNegDurationStrLst to the DateTime specified as String in the passed
  /// dateTimeStr. The result is returned as DateTime.
  ///
  /// In case the passed posNegDurationStrLst contains invalid duration strings
  /// (for example 2a:00), this duration is ignored, no FormatException is
  /// thrown.
  ///
  /// Usage examples:
  /// DateTimeComputer.addDurationsToDateTime('21-4-2022 13:34', ['20:00'])
  /// DateTimeComputer.addDurationsToDateTime('21-4-2022 13:34', ['0:15', '-8:15'])
  ///
  /// throws FormatException in case the passed dateTimeStr is not conform to
  ///                        its expected format
  static DateTime? addDurationsToDateTime({
    required String dateTimeStr,
    required List<String> posNegDurationStrLst,
  }) {
    DateTime dateTime = localDateTimeFormat.parse(dateTimeStr);

    for (String posNegDurationStr in posNegDurationStrLst) {
      final Duration? posNegDuration =
          DateTimeParser.parseHHMMDuration(posNegDurationStr);

      if (posNegDuration != null) {
        dateTime = dateTime.add(posNegDuration);
      }
    }

    return dateTime;
  }

  static Duration dateTimeDifference({
    required String firstDateTimeStr,
    required String secondDateTimeStr,
  }) {
    final DateTime firstDateTime = localDateTimeFormat.parse(firstDateTimeStr);
    final DateTime secondDateTime =
        localDateTimeFormat.parse(secondDateTimeStr);

    if (firstDateTime.isAfter(secondDateTime)) {
      return firstDateTime.difference(secondDateTime);
    } else {
      return secondDateTime.difference(firstDateTime);
    }
  }

  /// If the passed alarmHHmmTimeStr is after the current time, the
  /// returned dd-MM-yyyy HH:mm is still today.
  ///
  /// Else, i.e. if the passed alarmHHmmTimeStr is before the current
  /// time or is equal to the current time, then the returned
  /// dd-MM-yyyy HH:mm it is on tomorrow.
  ///
  /// In case the passed alarmHHmmTimeStr is invalid, '' is returned.
  ///
  /// If the conditionally set to false setToTomorrow parameter is true,
  /// then the returned alarm date time string is on tomorrow even the
  /// passed alarmHHmmTimeStr is after the current time. This makes
  /// sense if you click on the alarm yes button whwn the alarm was
  /// diaplayed before the alarm time (for example at 5:30 when the
  /// alarm time is 6:00 !).
  static String computeTodayOrTomorrowAlarmFrenchDateTimeStr({
    required String alarmHHmmTimeStr,
    bool setToTomorrow = false,
  }) {
    // solving the problem caused by 1 digit hour and/or minute
    // alarmHHmmTimeStr
    String formattedAlarmHHmmTimeStr =
        Utility.formatStringDuration(durationStr: alarmHHmmTimeStr);
    Duration? alarmHHmmTimeDuration =
        DateTimeParser.parseHHMMDuration(formattedAlarmHHmmTimeStr);

    if (alarmHHmmTimeDuration == null) {
      return '';
    }

    DateTime now = DateTime.now();
    int alarmHHmmTimeDurationInMinutes = alarmHHmmTimeDuration.inMinutes;
    DateTime todayAlarmDateTime = DateTime(
        now.year, now.month, now.day, 0, alarmHHmmTimeDurationInMinutes, 0);

    String alarmFrenchDateTimeStr;

    if (setToTomorrow) {
      alarmFrenchDateTimeStr =
          setAlarmToTomorrow(now, alarmHHmmTimeDurationInMinutes);
    } else {
      if (todayAlarmDateTime.isAfter(now)) {
        alarmFrenchDateTimeStr =
            frenchDateTimeFormat.format(todayAlarmDateTime);
      } else {
        alarmFrenchDateTimeStr =
            setAlarmToTomorrow(now, alarmHHmmTimeDurationInMinutes);
      }
    }

    return alarmFrenchDateTimeStr;
  }

  static String setAlarmToTomorrow(
      DateTime now, int alarmHHmmTimeDurationInMinutes) {
    DateTime tomorrowAlarmDateTime = DateTime(
        now.year, now.month, now.day + 1, 0, alarmHHmmTimeDurationInMinutes, 0);
    return frenchDateTimeFormat.format(tomorrowAlarmDateTime);
  }
}
