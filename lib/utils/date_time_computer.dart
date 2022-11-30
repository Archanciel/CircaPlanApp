import 'dart:io';
import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

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
          DateTimeParser.parseHHmmDuration(posNegDurationStr);

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
}
