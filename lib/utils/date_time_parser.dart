// adding method HHmm which returns the Duration formatted as HH:mm
import 'package:circa_plan/screens/screen_mixin.dart';
import 'package:circa_plan/utils/utility.dart';
import 'package:intl/intl.dart';

extension FormattedDayHourMinute on Duration {
  static final NumberFormat numberFormatTwoInt = NumberFormat('00');

  /// returns the Duration formatted as HH:mm
  String HHmm() {
    int durationMinute = inMinutes.remainder(60);
    String minusStr = '';

    if (this.inMinutes < 0) {
      minusStr = '-';
    }

    return "$minusStr${inHours.abs()}:${numberFormatTwoInt.format(durationMinute.abs())}";
  }

  /// returns the Duration formatted as dd:HH:mm
  String ddHHmm() {
    int durationMinute = inMinutes.remainder(60);
    String minusStr = '';
    int durationHour =
        Duration(minutes: (inMinutes - durationMinute)).inHours.remainder(24);
    int durationDay = Duration(hours: (inHours - durationHour)).inDays;

    if (inMinutes < 0) {
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
  static final RegExp regExpHHAnyMMTime = RegExp(r'(^[-]?\d+:\d+)');
  static final RegExp regExpAllHHMMTime = RegExp(r'([-]?\d+:\d{2})');
  static final RegExp regExpDDHHMMTime = RegExp(r'(^[-]?\d+:\d+:\d{2})');
  static final RegExp regExpDDHHAnyMMTime = RegExp(r'(^[-]?\d+:\d+:\d+)');

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
  static String? parseHHAnyMMTimeStr(String hourMinuteStr) {
    final RegExpMatch? match = regExpHHAnyMMTime.firstMatch(hourMinuteStr);
    final String? parsedHourMinuteStr = match?.group(1);

    return parsedHourMinuteStr;
  }

  /// Parses the passed hourMinuteStr formatted as hh:mm or h:mm or -hh:mm or
  /// -h:mm and returns the hh:mm, h:mm, -hh:mm or -h:mm parsed String or null
  /// if the passed hourMinuteStr does not respect the hh:mm or h:mm or -hh:mm
  /// or -h:mm format, like 03:2 or 3:2 or 03-02 or 03:a2 or -03:2 or -3:2 or
  /// -03-02 or -03:a2 for example.
  static List<String> parseAllHHMMTimeStr(String multipleHHmmContainingStr) {
    return regExpAllHHMMTime
        .allMatches(multipleHHmmContainingStr)
        .map((m) => m.group(0))
        .whereType<String>()
        .toList();
  }

  /// Parses the passed int or hourMinuteStr formatted as h or hh or hh:mm or
  /// h:mm or -hh:mm or -h or -hh or -h:mm and returns the hh:mm, h:mm, -hh:mm
  /// or -h:mm parsed String or null if the passed hourMinuteStr does not
  /// respect the hh:mm or h:mm or -hh:mm or -h:mm format, like 03:2 or 3:2 or
  /// 03-02 or 03:a2 or -03:2 or -3:2 or -03-02 or -03:a2 for example.
  static List<String> parseAllIntOrHHMMTimeStr(
      String preferredDurationsItemValue) {
    RegExp regExp = RegExp(r'[ ,]+');
    List<String> preferredDurationsItemValueStrLst =
        preferredDurationsItemValue.split(regExp);
    List<String> parsedTimeStrLst = preferredDurationsItemValueStrLst
        .map((e) => Utility.formatStringDuration(
              durationStr: e,
              removeMinusSign: false,
            ))
        .toList();

    return parsedTimeStrLst;
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

  /// Parses the passed hourAnyMinuteStr formatted as hh:anymm or h:anymm or
  /// -hh:anymm or -h:anymm and returns the hh:anymm, h:anymm, -hh:anymm or
  /// -h:anymm parsed String or null if the passed hourAnyMinuteStr does not
  /// respect the hh:anymm or h:anymm or -hh:anymm or -h:anymm format, like
  /// 03-02 or 03:a2 or -03-02 or -03:a2 for example.
  static String? parseDDHHAnyMMTimeStr(String dayHhourAnyMinuteStr) {
    final RegExpMatch? match =
        regExpDDHHAnyMMTime.firstMatch(dayHhourAnyMinuteStr);
    final String? parsedDayHourMinuteStr = match?.group(1);

    return parsedDayHourMinuteStr;
  }

  /// Parses the passed hourMinuteStr and returns a Duration instanciated
  /// with the parsed hour and minute values.
  static Duration? parseHHMMDuration(String hourMinuteStr) {
    final String? parsedHourMinuteStr =
        DateTimeParser.parseHHMMTimeStr(hourMinuteStr);

    if (parsedHourMinuteStr != null) {
      List<String> hourMinuteStrLst = parsedHourMinuteStr.split(':');
      List<int> hourMinuteIntLst = hourMinuteStrLst
          .map((element) => int.parse(element))
          .toList(growable: false);

      final int hourInt = hourMinuteIntLst[0].abs();
      int minuteInt = hourMinuteIntLst[1].abs();

      Duration duration = Duration(hours: hourInt, minutes: minuteInt);

      if (hourMinuteStrLst[0].startsWith('-')) {
        return Duration.zero - duration;
      } else {
        return duration;
      }
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

      int setNegative = 1;

      final int dayInt = hourMinuteIntLst[0];
      final int hourInt = hourMinuteIntLst[1];
      final int minuteInt = hourMinuteIntLst[2];

      Duration duration =
          Duration(days: dayInt, hours: hourInt, minutes: minuteInt);

      if (dayHourMinuteStr.startsWith('-00')) {
        return Duration.zero - duration;
      } else {
        return duration;
      }
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
      return createDayHourMinuteDuration(parsedDayHourMinuteStr);
    } else {
      final String? parsedHourMinuteStr =
          DateTimeParser.parseHHMMTimeStr(dayHourMinuteStr);
      if (parsedHourMinuteStr != null) {
        return createHourMinuteDuration(parsedHourMinuteStr);
      }
    }

    return null;
  }

  static Duration createHourMinuteDuration(String parsedHourMinuteStr) {
    List<String> dayHourMinuteStrLst = parsedHourMinuteStr.split(':');
    List<int> hourMinuteIntLst = dayHourMinuteStrLst
        .map((element) => int.parse(element))
        .toList(growable: false);
    
    final int hourInt = hourMinuteIntLst[0].abs();
    final int minuteInt = hourMinuteIntLst[1].abs();
    
    Duration duration = Duration(hours: hourInt, minutes: minuteInt);
    
    if (parsedHourMinuteStr.startsWith('-')) {
      return Duration.zero - duration;
    } else {
      return duration;
    }
  }

  static Duration createDayHourMinuteDuration(String parsedDayHourMinuteStr) {
    List<String> dayHourMinuteStrLst = parsedDayHourMinuteStr.split(':');
    List<int> dayHourMinuteIntLst = dayHourMinuteStrLst
        .map((element) => int.parse(element))
        .toList(growable: false);
    
    final int dayInt = dayHourMinuteIntLst[0].abs();
    final int hourInt = dayHourMinuteIntLst[1].abs();
    final int minuteInt = dayHourMinuteIntLst[2].abs();
    
    Duration duration =
        Duration(days: dayInt, hours: hourInt, minutes: minuteInt);
    
    if (parsedDayHourMinuteStr.startsWith('-')) {
      return Duration.zero - duration;
    } else {
      return duration;
    }
  }

  /// Parses the passed dayHourAnyMinuteStr or hourAnyMinuteStr and
  /// returns a Duration instanciated with the parsed hour and
  /// minute values.
  ///
  /// Example dayHourAnyMinuteStr: 00:00:9125 or 00:9125
  static Duration? parseDDHHAnyMMorHHAnyMMDuration(String dayHourAnyMinuteStr) {
    final String? parsedDayHourAnyMinuteStr =
        DateTimeParser.parseDDHHAnyMMTimeStr(dayHourAnyMinuteStr);

    if (parsedDayHourAnyMinuteStr != null) {
      return createDayHourMinuteDuration(parsedDayHourAnyMinuteStr);
    } else {
      final String? parsedHourAnyMinuteStr =
          DateTimeParser.parseHHAnyMMTimeStr(dayHourAnyMinuteStr);
      if (parsedHourAnyMinuteStr != null) {
        return createHourMinuteDuration(parsedHourAnyMinuteStr);
      }
    }

    return null;
  }

  /// Returns the english formatted passed french formatted date
  /// time string. In case the passed date time string format
  /// is invalid, null is returned.
  static String? convertFrenchFormatToEnglishFormatDateTimeStr(
      {required String frenchFormatDateTimeStr}) {
    DateTime? endDateTime;
    String? englishFormatDateTimeStr;

    try {
      endDateTime =
          ScreenMixin.frenchDateTimeFormat.parse(frenchFormatDateTimeStr);
    } on FormatException {}

    if (endDateTime != null) {
      englishFormatDateTimeStr =
          ScreenMixin.englishDateTimeFormat.format(endDateTime);
    }

    return englishFormatDateTimeStr;
  }

  /// Returns the french formatted passed english formatted date
  /// time string. In case the passed date time string format
  /// is invalid, null is returned.
  static String? convertEnglishFormatToFrenchFormatDateTimeStr(
      {required String englishFormatDateTimeStr}) {
    DateTime? endDateTime;
    String? frenchFormatDateTimeStr;

    try {
      endDateTime =
          ScreenMixin.englishDateTimeFormat.parse(englishFormatDateTimeStr);
    } on FormatException {}

    if (endDateTime != null) {
      frenchFormatDateTimeStr =
          ScreenMixin.frenchDateTimeFormat.format(endDateTime);
    }

    return frenchFormatDateTimeStr;
  }
}
