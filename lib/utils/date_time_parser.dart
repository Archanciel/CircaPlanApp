// adding method HHmm which returns the Duration formatted as HH:mm
import 'package:intl/intl.dart';

extension FormattedHourMinute on Duration {
  static final NumberFormat numberFormatTwoInt = NumberFormat('00');

  /// returns the Duration formatted as HH:mm
  String HHmm() {
    int durationMinute = this.inMinutes.remainder(60);
    String minusStr = '';

    if (this.inMinutes < 0) {
      if (this.inHours == 0) {
        minusStr = '-';
      }
      durationMinute = -durationMinute;
    }

    return "$minusStr${this.inHours}:${numberFormatTwoInt.format(durationMinute)}";
  }
}

class DateTimeParser {
  static final RegExp regExpYYYYDateTime = RegExp(r'^(\d+-\d+-\d{4})\s(\d+:\d{2})');
  static final RegExp regExpNoYearDateTime = RegExp(r'^(\d+-\d+)\s(\d+:\d{2})');
  static final RegExp regExpTime = RegExp(r'(^[-]?\d+:\d{2})');

  /// Parses the passed ddMMDateTimeStr formatted as dd-mm hh:mm or d-m h:mm
  static List<String?> parseDDMMDateTime(String ddMMDateTimrStr) {
    final RegExpMatch? match = regExpNoYearDateTime.firstMatch(ddMMDateTimrStr);
    final String? dayMonth = match?.group(1);
    final String? hourMinute = match?.group(2);

    return [dayMonth, hourMinute];
  }

  /// Parses the passed ddMMyyyyDateTimeStr formatted as dd-mm-yyyy hh:mm or d-m-yyyy h:mm
  static List<String?> parseDDMMYYYYDateTime(String ddMMyyyyDateTimrStr) {
    final RegExpMatch? match = regExpYYYYDateTime.firstMatch(ddMMyyyyDateTimrStr);
    final String? dayMonthYear = match?.group(1);
    final String? hourMinute = match?.group(2);

    return [dayMonthYear, hourMinute];
  }

  /// Parses the passed hourMinuteStr formatted as hh:mm or h:mm or -hh:mm or
  /// -h:mm and returns the hh:mm, h:mm, -hh:mm or -h:mm parsed String or null
  /// if the passed hourMinuteStr does not respect the hh:mm or h:mm or -hh:mm
  /// or -h:mm format, like 03:2 or 3:2 or 03-02 or 03:a2 or -03:2 or -3:2 or
  /// -03-02 or -03:a2 for example.
  static String? parseTime(String hourMinuteStr) {
    final RegExpMatch? match = regExpTime.firstMatch(hourMinuteStr);
    final String? parsedHourMinuteStr = match?.group(1);

    return parsedHourMinuteStr;
  }

  /// Parses the passed hourMinuteStr and returns a Duration instanciated
  /// with the parsed hour and minute values.
  static Duration? parseHHmmDuration(String hourMinuteStr) {
    final String? parsedHourMinuteStr = DateTimeParser.parseTime(hourMinuteStr);

    if (parsedHourMinuteStr != null) {
      List<String> hourMinuteStrLst = parsedHourMinuteStr.split(':');
      List<int> hourMinuteIntLst = hourMinuteStrLst
          .map((element) => int.parse(element))
          .toList(growable: false);

      final int hourInt = hourMinuteIntLst[0];
      int minuteInt = hourMinuteIntLst[1];

      if (hourMinuteStrLst[0].contains('-0')) {
        // the case for hourMinuteStr == '-0:01' (minus 1 minute) for example
        return Duration(minutes: -minuteInt);
      }

      if (hourInt < 0) {
        // if this test was not performed, parsing -8:45 would return a
        // Duration of -7:15:00.000000
        minuteInt = -minuteInt;
      }

      return Duration(hours: hourMinuteIntLst[0], minutes: minuteInt);
    }

    return null;
  }
}

void main() {
  const List<String> dateTimeNoYearStrLst = [
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
    '14-2 3:u5',
    '14-2 3:5',
    // new
    '14-12-2022 13:35',
    '4-2-2022 3:05',
    'a4-2-2022 3:05',
    '14-2-2022 3:u5',
    '14-2-2022 3:5',
  ];

  // new
  const List<String> dateTimeYYYYStrLst = [
    '14-12-2022 13:35',
    '4-2-2022 3:05',
    'a4-2-2022 3:05',
    '14-2-2022 3:u5',
    '14-2-2022 3:5',
    '4-2-22 3:05',
    'a4-2-22 3:05',
    '14-2-22 3:u5',
    '14-2-22 3:5',
  ];

  const List<String> timeStrLst = [
    '13:35',
    '3:05',
    '0:05',
    '3:u5',
    '3:5',
    '3-05',
    '3-5',
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
    // new
    '14-12-2022 13:35',
    '4-2-2022 3:05',
    'a4-2-2022 3:05',
    '14-12-22 3:05',
    '4-2-22 3:05',
    'a4-2-22 3:05',
  ];

  const List<String> negativeTimeStrLst = [
    '-13:35',
    '-3:05',
    '-0:05',
    '-3-05',
    '-3:u5',
    '-3:5',
    '-3-5',
  ];

  print('\nDateTimeParser.parseDDMMDateTime()\n');

  for (String str in dateTimeNoYearStrLst) {
    List<String?> dateTimeStrLst = DateTimeParser.parseDDMMDateTime(str);
    String? dayMonth = dateTimeStrLst[0];
    String? hourMinute = dateTimeStrLst[1];
    print('String $str parsed as: $dayMonth $hourMinute');
  }

  print('\nDateTimeParser.parseDDMMYYYYDateTime()\n');

  for (String str in dateTimeYYYYStrLst) {
    List<String?> dateTimeStrLst = DateTimeParser.parseDDMMYYYYDateTime(str);
    String? dayMonthYear = dateTimeStrLst[0];
    String? hourMinute = dateTimeStrLst[1];
    print('String $str parsed as: $dayMonthYear $hourMinute');
  }

  print('\nDateTimeParser.parseTime()\n');

  for (String str in timeStrLst) {
    String? hourMinute = DateTimeParser.parseTime(str);
    print('String $str parsed as: $hourMinute');
  }

  print('');

  for (String str in negativeTimeStrLst) {
    String? hourMinute = DateTimeParser.parseTime(str);
    print('String $str parsed as: $hourMinute');
  }

  print('\nDateTimeParser.parseDuration()\n');

  for (String str in timeStrLst) {
    Duration? duration = DateTimeParser.parseHHmmDuration(str);
    print(
        'String $str parsed as Duration: $duration HHmm: ${duration?.HHmm()}');
  }

  print('');

  for (String str in negativeTimeStrLst) {
    Duration? duration = DateTimeParser.parseHHmmDuration(str);
    print(
        'String $str parsed as Duration: $duration HHmm: ${duration?.HHmm()}');
  }

  print('');

  print(Duration(hours: -1)); // -1:00:00.000000
  print(Duration.zero - Duration(hours: 1)); // -1:00:00.000000
  print(Duration(minutes: -1)
      .HHmm()); // 0:01:00.000000 instead of -0:01:00.000000
  print((Duration.zero - Duration(minutes: 1))
      .HHmm()); // 0:01:00.000000 instead of -0:01:00.000000
  print(Duration(minutes: -1).inMinutes); // -1
  print((Duration.zero - Duration(minutes: 1)).inMinutes); // -1

  print(Duration(hours: -1, minutes: -12)); // -1:00:00.000000
  print(Duration.zero - Duration(hours: 1)); // -1:00:00.000000
}
