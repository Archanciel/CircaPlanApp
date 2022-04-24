import 'dart:io';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:circa_plan/utils/date_time_parser.dart';

class DateTimeComputer {
  static DateTime? addDurationToDateTime({
    required DateTime dateTime,
    required posNegDurationStr,
  }) {
    final Duration? posNegDuration =
        DateTimeParser.parseHHmmDuration(posNegDurationStr);

    if (posNegDuration != null) {
      return dateTime.add(posNegDuration);
    }

    return null;
  }
}

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);
  final DateFormat localDateTimeFormat =
      DateFormat('dd-MM-yyyy HH:mm', localName);
  final DateFormat localDateTimeFormatDayName =
      DateFormat("EEEE dd-MM-yyyy HH:mm", localName);

  final DateTime wakeUpHour = localDateTimeFormat.parse('23-4-2022 18:00');
  final DateTime? goToBedHour = DateTimeComputer.addDurationToDateTime(
    dateTime: wakeUpHour,
    posNegDurationStr: '20:00',
  );

  if (goToBedHour != null) {
    print(
        '${localDateTimeFormat.format(wakeUpHour)} + 20:00 = ${localDateTimeFormat.format(goToBedHour)}');
  }

  print('');

  const List<List<String>> testDataLst = [
    ['23-4-2022 18:00', '28:00'],
    ['15-04-2022 18:15', '20:00'],
    ['16-4-2022 15:30', '-10:30'],
    ['16-4-2022 15:30', '-8:15'],
  ];

  for (List<String> twoParmsLst in testDataLst) {
    final DateTime dateTimeStart = localDateTimeFormat.parse(twoParmsLst[0]);
    final String durationStr = twoParmsLst[1];
    final DateTime? dateTimeEnd = DateTimeComputer.addDurationToDateTime(
        dateTime: dateTimeStart, posNegDurationStr: durationStr);
    if (dateTimeEnd != null) {
      print(
          '${localDateTimeFormat.format(dateTimeStart)} + $durationStr = ${localDateTimeFormat.format(dateTimeEnd)}');
    }
  }
}
