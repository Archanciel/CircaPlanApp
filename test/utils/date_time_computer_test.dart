import 'dart:io';

import 'package:circa_plan/constants.dart';
import 'package:circa_plan/utils/date_time_computer.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

import 'package:circa_plan/utils/date_time_computer.dart' as dtc;

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);
  const sirdalud5hoursDuration = Duration(hours: 5);

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
        'invalid date time string + 2 valid durations exception type only',
        () {
          expect(
              () => dtc.DateTimeComputer.addDurationsToDateTime(
                    dateTimeStr: '23-4-2022 1a:00',
                    posNegDurationStrLst: [
                      '20:00',
                      '8:00',
                    ],
                  ),
              throwsA(isA<FormatException>()));
        },
      );
      test(
        'invalid date time string + 2 valid durations exception type + message',
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
                  e.message == 'Trying to read : from 23-4-2022 1a:00 at 12')));
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
        'alarm date time 1 hour after now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourLater =
              DateTime(now.year, now.month, now.day, now.hour + 1, now.minute);

          int minuteInt = oneHourLater.minute;
          String minuteStr;

          if (minuteInt > 9) {
            minuteStr = minuteInt.toString();
          } else {
            minuteStr = '0${minuteInt.toString()}';
          }

          int hourInt = oneHourLater.hour;
          String hourStr;

          if (hourInt > 9) {
            hourStr = hourInt.toString();
          } else {
            hourStr = '0${hourInt.toString()}';
          }

          expect(
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '$hourStr:$minuteStr',
                alarmFrenchDateTimeStr: frenchDateTimeFormat.format(oneHourLater),
              ),
              // '$dayStr-$monthStr-${now.year} $hourStr:$minuteStr');
              frenchDateTimeFormat.format(oneHourLater.add(sirdalud5hoursDuration)));
        },
      );
      test(
        'alarm date time 1 hour before now',
        () {
          DateTime now = DateTime.now();

          DateTime oneHourBefore =
              DateTime(now.year, now.month, now.day, now.hour - 1, now.minute);

          int minuteInt = oneHourBefore.minute;
          String minuteStr;

          if (minuteInt > 9) {
            minuteStr = minuteInt.toString();
          } else {
            minuteStr = '0${minuteInt.toString()}';
          }

          int hourInt = oneHourBefore.hour;
          String hourStr;

          if (hourInt > 9) {
            hourStr = hourInt.toString();
          } else {
            hourStr = '0${hourInt.toString()}';
          }

          expect(
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(

                alarmHHmmTimeStr: '$hourStr:$minuteStr',
                alarmFrenchDateTimeStr: frenchDateTimeFormat.format(oneHourBefore),
              ),
              frenchDateTimeFormat.format(oneHourBefore.add(sirdalud5hoursDuration)));
        },
      );
      test(
        'alarm date time before now with 1 digit hour 2 digits minutes',
        () {
          DateTime now = DateTime.now();

          DateTime dateTime_2_35 =
              DateTime(now.year, now.month, now.day, 2, 35);

          expect(
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '2:35',
                alarmFrenchDateTimeStr: frenchDateTimeFormat.format(dateTime_2_35),
              ),
              frenchDateTimeFormat.format(dateTime_2_35.add(sirdalud5hoursDuration)));
        },
      );
      test(
        'alarm date time before now with 2 digits hour 1 digit minutes',
        () {
          DateTime now = DateTime.now();

          DateTime dateTime_10_30 =
              DateTime(now.year, now.month, now.day, 10, 30);

          expect(
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '10:3',
                alarmFrenchDateTimeStr: frenchDateTimeFormat.format(dateTime_10_30),
              ),
              frenchDateTimeFormat.format(dateTime_10_30.add(sirdalud5hoursDuration)));
        },
      );
      test(
        'alarm date time equals now and alarm duration equals 5 hours',
        () {
          DateTime dateTimeNow = DateTime.now();

          int minuteInt = dateTimeNow.minute;
          String minuteStr;

          if (minuteInt > 9) {
            minuteStr = minuteInt.toString();
          } else {
            minuteStr = '0${minuteInt.toString()}';
          }

          int hourInt = dateTimeNow.hour;
          String hourStr;

          if (hourInt > 9) {
            hourStr = hourInt.toString();
          } else {
            hourStr = '0${hourInt.toString()}';
          }

          // if alarm time is now time, then it makes no sense to
          // define an alarm for now, so we define it for 5 hours
          // later than now.

          expect(
              DateTimeComputer.computeTodayOrTomorrowNextAlarmFrenchDateTimeStr(
                alarmHHmmTimeStr: '$hourStr:$minuteStr',
                alarmFrenchDateTimeStr: frenchDateTimeFormat.format(dateTimeNow),
              ),
              frenchDateTimeFormat.format(dateTimeNow.add(sirdalud5hoursDuration)));
        },
      );
    },
  );
}
