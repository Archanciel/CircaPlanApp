import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
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
  /// Usage examples:
  /// DateTimeComputer.addDurationsToDateTime('21-4-2022 13:34', ['20:00'])
  /// DateTimeComputer.addDurationsToDateTime('21-4-2022 13:34', ['0:15', '-8:15'])
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

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);
  final DateFormat localDateTimeFormat =
      DateFormat('dd-MM-yyyy HH:mm', localName);
  final DateFormat localDateTimeFormatDayName =
      DateFormat("EEEE dd-MM-yyyy HH:mm", localName);

  final DateTime? goToBedHour = DateTimeComputer.addDurationsToDateTime(
    dateTimeStr: '23-4-2022 18:00',
    posNegDurationStrLst: ['20:00'],
  );

  if (goToBedHour != null) {
    print(
        '23-4-2022 18:00 + 20:00 = ${localDateTimeFormat.format(goToBedHour)}');
  }

  print('');

  // to be implemented in test_date_time_computer:

  const List<List<String>> testAddDurationtDateTimeDataLst = [
    [
      '23-4-2022 18:00',
      '20:00',
      '8:00',
    ],
    [
      '23-4-2022 18:00',
      '20:00',
      '3:16',
    ],
    [
      '15-04-2022 18:15',
      '20:00',
    ],
    ['16-4-2022 15:30', '-10:30', '-3:45', '0:15'],
    [
      '16-4-2022 15:30',
      '4:00',
      '-8:15',
    ],
    [
      '16-4-2022 15:30',
      '-0:01',
    ],
    [
      '16-4-2022 15:30',
      '-0:01',
      '1:5',
      '-0:02',
    ],
  ];

  for (List<String> twoParmsLst in testAddDurationtDateTimeDataLst) {
    final String dateTimeStartStr = twoParmsLst[0];
    final List<String> durationStrLst = twoParmsLst.sublist(1);
    final DateTime? dateTimeEnd = DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: dateTimeStartStr, posNegDurationStrLst: durationStrLst);
    if (dateTimeEnd != null) {
      print(
          '$dateTimeStartStr + $durationStrLst = ${localDateTimeFormat.format(dateTimeEnd)}');
    }
  }

  print('');

  String firstDTStr = '22-4-2022 21:30';
  String secondDTStr = '24-4-2022 13:30';
  Duration dateTimeDifference = DateTimeComputer.dateTimeDifference(
    firstDateTimeStr: firstDTStr,
    secondDateTimeStr: secondDTStr,
  );

  print('diff $firstDTStr $secondDTStr = ${dateTimeDifference.HHmm()}');

  dateTimeDifference = DateTimeComputer.dateTimeDifference(
    firstDateTimeStr: secondDTStr,
    secondDateTimeStr: firstDTStr,
  );

  print('diff $secondDTStr $firstDTStr = ${dateTimeDifference.HHmm()}');

  // to be implemented in test_date_time_computer:

  const List<List<String>> testDateTimeDifferenceDataLst = [
    ['22-4-2022 21:30', '24-4-2022 13:30'],
    ['24-4-2022 13:30', '22-4-2022 21:30'],
    ['24-4-2022 13:30', '24-4-2022 13:30'],
    ['24-4-2022 13:30', '24-4-2022 13:31'],
    ['24-4-2022 13:31', '24-4-2022 13:30'],
    ['23-4-2022 18:00', '24-4-2022 17:16'],
    ['24-4-2022 17:16', '23-4-2022 18:00'],
  ];

  print('');

  Duration dateTimeDiffDuration;

  for (List<String> firstSecDTStr in testDateTimeDifferenceDataLst) {
    var firstSecDTStrOne = firstSecDTStr[0];
    var firstSecDTStrTwo = firstSecDTStr[1];
    dateTimeDiffDuration = DateTimeComputer.dateTimeDifference(
      firstDateTimeStr: firstSecDTStrOne,
      secondDateTimeStr: firstSecDTStrTwo,
    );
    print(
        'diff $firstSecDTStrOne $firstSecDTStrTwo = ${dateTimeDiffDuration.HHmm()}');
  }

  // verifying that adding the difference duration between goToBedDateTimeStr
  // and wakeUpDateTimeStr to wakeUpDateTimeStr returns goToBedDateTimeStr
  const String wakeUpDateTimeStr = '23-4-2022 18:00';
  const String goToBedDateTimeStr = '24-4-2022 17:16';
  String wakeDurationStr = DateTimeComputer.dateTimeDifference(
    firstDateTimeStr: wakeUpDateTimeStr,
    secondDateTimeStr: goToBedDateTimeStr,
  ).HHmm();

  final DateTime? computedGoToBedDateTimeStr =
      DateTimeComputer.addDurationsToDateTime(
          dateTimeStr: wakeUpDateTimeStr,
          posNegDurationStrLst: [wakeDurationStr]);

  print(
      '$goToBedDateTimeStr = ${localDateTimeFormat.format(computedGoToBedDateTimeStr!)}');

  print('');

  final String dateTimeNowStr = localDateTimeFormat.format(DateTime.now());
  String wakeDurationNowStr = DateTimeComputer.dateTimeDifference(
    firstDateTimeStr: wakeUpDateTimeStr,
    secondDateTimeStr: dateTimeNowStr,
  ).HHmm();

  print('$wakeUpDateTimeStr to $dateTimeNowStr = $wakeDurationNowStr');
}
