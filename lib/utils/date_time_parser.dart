// adding method HHmm which returns the Duration formatted as HH:mm
import 'package:intl/intl.dart';

extension FormattedDayHourMinute on Duration {
  static final NumberFormat numberFormatTwoInt = NumberFormat('00');

  /// returns the Duration formatted as HH:mm
  String HHmm() {
    int durationMinute = this.inMinutes.remainder(60);
    String minusStr = '';

    if (this.inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${this.inHours.abs()}:${numberFormatTwoInt.format(durationMinute.abs())}";
  }

  /// returns the Duration formatted as HH:mm
  String ddHHmm() {
    int durationMinute = this.inMinutes.remainder(60);
    String minusStr = '';
    int durationHour = Duration(minutes: (this.inMinutes - durationMinute))
        .inHours
        .remainder(24);
    int durationDay = Duration(hours: (this.inHours - durationHour)).inDays;

    if (this.inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${numberFormatTwoInt.format(durationDay.abs())}:${numberFormatTwoInt.format(durationHour.abs())}:${numberFormatTwoInt.format(durationMinute.abs())}";
  }
}

class DateTimeParser {
  static final RegExp regExpYYYYDateTime =
      RegExp(r'^(\d+-\d+-\d{4})\s(\d+:\d{2})');
  static final RegExp regExpNoYearDateTime = RegExp(r'^(\d+-\d+)\s(\d+:\d{2})');
  static final RegExp regExpHHMMTime = RegExp(r'(^[-]?\d+:\d{2})');
  static final RegExp regExpDDHHMMTime = RegExp(r'(^\d+:\d+:\d{2})');

  /// Parses the passed ddMMDateTimeStr formatted as dd-mm hh:mm or d-m h:mm
  static List<String?> parseDDMMDateTime(String ddMMDateTimrStr) {
    final RegExpMatch? match = regExpNoYearDateTime.firstMatch(ddMMDateTimrStr);
    final String? dayMonth = match?.group(1);
    final String? hourMinute = match?.group(2);

    return [dayMonth, hourMinute];
  }

  /// Parses the passed ddMMyyyyDateTimeStr formatted as dd-mm-yyyy hh:mm or d-m-yyyy h:mm
  static DateTime? parseDDMMYYYYDateTime(String ddMMyyyyDateTimrStr) {
    final RegExpMatch? match =
        regExpYYYYDateTime.firstMatch(ddMMyyyyDateTimrStr);
    final String? dayMonthYear = match?.group(1);
    final String? hourMinute = match?.group(2);

    DateTime? dateTime;

    if (dayMonthYear != null && hourMinute != null) {
      List<String> dayMonthYearStrLst = dayMonthYear.split('-');
      List<int?> dayMonthYearIntLst = dayMonthYearStrLst
          .map((element) => int.tryParse(element))
          .toList(growable: false);
      List<String> hourMinuteStrLst = hourMinute.split(':');
      List<int?> hourMinuteIntLst = hourMinuteStrLst
          .map((element) => int.tryParse(element))
          .toList(growable: false);

      if (!dayMonthYearIntLst.contains(null) &&
          !hourMinuteIntLst.contains(null)) {
        dateTime = DateTime(
          dayMonthYearIntLst[2] ?? 0, // year
          dayMonthYearIntLst[1] ?? 0, // month
          dayMonthYearIntLst[0] ?? 0, // day
          hourMinuteIntLst[0] ?? 0, // hour
          hourMinuteIntLst[1] ?? 0, // minute
        );
      }
    }

    return dateTime;
  }

  /// Parses the passed hourMinuteStr formatted as hh:mm or h:mm or -hh:mm or
  /// -h:mm and returns the hh:mm, h:mm, -hh:mm or -h:mm parsed String or null
  /// if the passed hourMinuteStr does not respect the hh:mm or h:mm or -hh:mm
  /// or -h:mm format, like 03:2 or 3:2 or 03-02 or 03:a2 or -03:2 or -3:2 or
  /// -03-02 or -03:a2 for example.
  static String? parseHHMMTimeStr(String hourMinuteStr) {
    final RegExpMatch? match = regExpHHMMTime.firstMatch(hourMinuteStr);
    final String? parsedHourMinuteStr = match?.group(1);

    return parsedHourMinuteStr;
  }

  /// Parses the passed hourMinuteStr formatted as hh:mm or h:mm or -hh:mm or
  /// -h:mm and returns the hh:mm, h:mm, -hh:mm or -h:mm parsed String or null
  /// if the passed hourMinuteStr does not respect the hh:mm or h:mm or -hh:mm
  /// or -h:mm format, like 03:2 or 3:2 or 03-02 or 03:a2 or -03:2 or -3:2 or
  /// -03-02 or -03:a2 for example.
  static String? parseDDHHMMTimeStr(String dayHhourMinuteStr) {
    final RegExpMatch? match = regExpDDHHMMTime.firstMatch(dayHhourMinuteStr);
    final String? parsedDayHourMinuteStr = match?.group(1);

    return parsedDayHourMinuteStr;
  }

  /// Parses the passed hourMinuteStr and returns a Duration instanciated
  /// with the parsed hour and minute values.
  static Duration? parseHHmmDuration(String hourMinuteStr) {
    final String? parsedHourMinuteStr =
        DateTimeParser.parseHHMMTimeStr(hourMinuteStr);

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

  /// Parses the passed dayHourMinuteStr and returns a Duration
  /// instanciated with the parsed day, hour and minute values.
  static Duration? parseDDHHMMDuration(String dayHourMinuteStr) {
    final String? parsedDayHourMinuteStr =
        DateTimeParser.parseDDHHMMTimeStr(dayHourMinuteStr);

    if (parsedDayHourMinuteStr != null) {
      List<String> dayHourMinuteStrLst = parsedDayHourMinuteStr.split(':');
      List<int> hourMinuteIntLst = dayHourMinuteStrLst
          .map((element) => int.parse(element))
          .toList(growable: false);

      final int dayInt = hourMinuteIntLst[0];
      final int hourInt = hourMinuteIntLst[1];
      final int minuteInt = hourMinuteIntLst[2];

      return Duration(days: dayInt, hours: hourInt, minutes: minuteInt);
    }

    return null;
  }

  /// Parses the passed dayHourMinuteStr or hourMinuteStr and
  /// returns a Duration instanciated with the parsed hour and
  /// minute values.
  static Duration? parseDDHHMMorHHMMDuration(String dayHourMinuteStr) {
    final String? parsedDayHourMinuteStr =
        DateTimeParser.parseDDHHMMTimeStr(dayHourMinuteStr);

    if (parsedDayHourMinuteStr != null) {
      List<String> dayHourMinuteStrLst = parsedDayHourMinuteStr.split(':');
      List<int> dayHourMinuteIntLst = dayHourMinuteStrLst
          .map((element) => int.parse(element))
          .toList(growable: false);

      final int dayInt = dayHourMinuteIntLst[0];
      final int hourInt = dayHourMinuteIntLst[1];
      final int minuteInt = dayHourMinuteIntLst[2];

      return Duration(days: dayInt, hours: hourInt, minutes: minuteInt);
    } else {
      final String? parsedHourMinuteStr =
          DateTimeParser.parseHHMMTimeStr(dayHourMinuteStr);
      if (parsedHourMinuteStr != null) {
        List<String> dayHourMinuteStrLst = parsedHourMinuteStr.split(':');
        List<int> hourMinuteIntLst = dayHourMinuteStrLst
            .map((element) => int.parse(element))
            .toList(growable: false);

        final int hourInt = hourMinuteIntLst[0];
        final int minuteInt = hourMinuteIntLst[1];

        return Duration(hours: hourInt, minutes: minuteInt);
      }
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
    '04-02-2022 3:05',
    '4-2-2022 3:00',
    '4-2-2022 3:0',
    'a4-2-2022 3:05',
    '14-2-2022 3:u5',
    '14-2-2022 3:5',
  ];

  // new
  const List<String> dateTimeYYYYStrLst = [
    '14-12-2022 13:35',
    '4-2-2022 3:05',
    '04-02-2022 3:05',
    '4-2-2022 3:00',
    '4-2-2022 3:0',
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

  Duration dur = Duration(days: 2, hours: 10, minutes: 30);
  print(dur.inMinutes);
  print(dur.ddHHmm());

  print('\nDateTimeParser.parseDDMMDateTime()\n');

  for (String str in dateTimeNoYearStrLst) {
    List<String?> dateTimeStrLst = DateTimeParser.parseDDMMDateTime(str);
    String? dayMonth = dateTimeStrLst[0];
    String? hourMinute = dateTimeStrLst[1];
    print('String $str parsed as: $dayMonth $hourMinute');
  }

  print('\nDateTimeParser.parseDDMMYYYYDateTime()\n');

  for (String str in dateTimeYYYYStrLst) {
    DateTime? dateTime = DateTimeParser.parseDDMMYYYYDateTime(str);
    print('String $str parsed as: ${dateTime.toString()}');
  }

  print('\nDateTimeParser.parseTime()\n');

  for (String str in timeStrLst) {
    String? hourMinute = DateTimeParser.parseHHMMTimeStr(str);
    print('String $str parsed as: $hourMinute');
  }

  print('');

  for (String str in negativeTimeStrLst) {
    String? hourMinute = DateTimeParser.parseHHMMTimeStr(str);
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
