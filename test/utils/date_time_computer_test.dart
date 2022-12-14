import 'dart:io';

import 'package:circa_plan/utils/date_time_computer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

import 'package:circa_plan/utils/date_time_computer.dart' as dtc;

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);

  group(
    'addDurationsToDateTime()',
    () {
      test(
        'valid date time string + 1 durations',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '15-4-2022 18:15',
            posNegDurationStrLst: [
              '20:00',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 16, 14, 15));
        },
      );

      test(
        'valid date time string + 2 durations',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '23-4-2022 18:00',
            posNegDurationStrLst: [
              '20:00',
              '8:00',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 24, 22, 0));
        },
      );

      test(
        'valid date time string + 2 durations result not 0 minute',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '23-4-2022 18:00',
            posNegDurationStrLst: [
              '20:00',
              '3:16',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 24, 17, 16));
        },
      );

      test(
        'valid date time string + 3 durations 2 negatives',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '16-4-2022 15:30',
            posNegDurationStrLst: [
              '-10:30',
              '-3:45',
              '0:15',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 16, 1, 30));
        },
      );

      test(
        'valid date time string + 2 durations 1 negative',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '16-4-2022 15:30',
            posNegDurationStrLst: [
              '4:00',
              '-8:15',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 16, 11, 15));
        },
      );

      test(
        'valid date time string + 1 durations min neg duration',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '16-4-2022 15:30',
            posNegDurationStrLst: [
              '-0:01',
            ],
          );
          expect(dateTime, DateTime(2022, 4, 16, 15, 29));
        },
      );

      test(
        'valid date time string + 3 durations min 2 neg duration',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '16-4-2022 15:30',
            posNegDurationStrLst: [
              '-0:01',
              '1:5',
              '-0:02',
            ],
          );
          expect(dateTime, DateTime(2022, 4, 16, 15, 27));
        },
      );

      test(
        'invalid date time string + 2 valid durations',
        () {
          expect(
              () => dtc.DateTimeComputer.addDurationsToDateTime(
                    dateTimeStr: '23-4-2022 1a:00',
                    posNegDurationStrLst: [
                      '20:00',
                      '8:00',
                    ],
                  ),
              throwsA(predicate((e) =>
                  e is FormatException &&
                  e.message ==
                      'Trying to read : from 23-4-2022 1a:00 at position 12')));
        },
      );

      test(
        'valid date time string + 1 invalid duration',
        () {
          final DateTime? dateTime =
              dtc.DateTimeComputer.addDurationsToDateTime(
            dateTimeStr: '23-4-2022 18:00',
            posNegDurationStrLst: [
              '2a:00',
            ],
          );

          expect(dateTime, DateTime(2022, 4, 23, 18, 0));
        },
      );
    },
  );
  group(
    'computeTodayOrTomorrowAlarmFrenchDateTimeStr setToTomorrow = false',
    () {
      test(
        'alarm date time after now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour + 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
              ),
              '${now.day}-${now.month}-${now.year} ${now.hour + 1}:${now.minute}');
        },
      );
      test(
        'alarm date time before now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
              ),
              '${now.day + 1}-${now.month}-${now.year} ${now.hour - 1}:${now.minute}');
        },
      );
      test(
        'alarm date time before now with 1 digit hour 2 digits minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '2:23',
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:23');
        },
      );
      test(
        'alarm date time before now with 1 digit hour 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '2:3',
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:30');
        },
      );
      test(
        'alarm date time before now with 2 digits hour starting with 0 and 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '02:3',
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:30');
        },
      );
      test(
        'alarm date time before now with 2 digits hour 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '10:3',
              ),
              '${now.day + 1}-${now.month}-${now.year} 10:30');
        },
      );
      test(
        'alarm date time equal now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
              ),
              '${now.day + 1}-${now.month}-${now.year} ${now.hour}:${now.minute}');
        },
      );
    },
  );
  group(
    'computeTodayOrTomorrowAlarmFrenchDateTimeStr setToTomorrow = true',
    () {
      test(
        'alarm date time after now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour + 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} ${now.hour + 1}:${now.minute}');
        },
      );
      test(
        'alarm date time before now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} ${now.hour - 1}:${now.minute}');
        },
      );
      test(
        'alarm date time before now with 1 digit hour 2 digits minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '2:23',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:23');
        },
      );
      test(
        'alarm date time before now with 1 digit hour 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '2:3',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:30');
        },
      );
      test(
        'alarm date time before now with 2 digits hour starting with 0 and 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '02:3',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} 02:30');
        },
      );
      test(
        'alarm date time before now with 2 digits hour 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '10:3',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} 10:30');
        },
      );
      test(
        'alarm date time equal now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour, now.minute);

          expect(
              DateTimeComputer.computeTodayOrTomorrowAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '${oneHourLater.hour}:${oneHourLater.minute}',
                setToTomorrow: true,
              ),
              '${now.day + 1}-${now.month}-${now.year} ${now.hour}:${now.minute}');
        },
      );
    },
  );
}
