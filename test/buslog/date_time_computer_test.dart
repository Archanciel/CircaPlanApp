import 'package:test/test.dart';

import 'package:circa_plan/buslog/date_time_computer.dart';

void main() {
  group(
    'DateTimeComputer',
    () {
      final DateTimeComputer dateTimeComputer = DateTimeComputer();

      test(
        'computeGoToSleepHour valid params',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String wakeHourMinuteDuration = '20:30';
          final DateTime goToSleepHour = dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration);

          expect(goToSleepHour, DateTime(2022, 4, 16, 14, 45));
        },
      );

      test(
        'computeGoToSleepHour invalid wakeUpDateTime value',
        () {
          const String wakeUpDateTime = '31-04-2022 18:15';
          const String wakeHourMinuteDuration = '20:30';

          expect(
              () => dateTimeComputer.computeGoToSleepHour(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  wakeHourMinuteDurationStr: wakeHourMinuteDuration),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        'computeGoToSleepHour invalid wakeUp date format',
        () {
          const String wakeUpDateTime = '30/04/2022 18:15';
          const String wakeHourMinuteDuration = '20:30';

          expect(
              () => dateTimeComputer.computeGoToSleepHour(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  wakeHourMinuteDurationStr: wakeHourMinuteDuration),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        'computeGoToSleepHour invalid wakeUp time format',
        () {
          const String wakeUpDateTime = '31-04-2022 18-15';
          const String wakeHourMinuteDuration = '20:30';

          expect(
              () => dateTimeComputer.computeGoToSleepHour(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  wakeHourMinuteDurationStr: wakeHourMinuteDuration),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        'computeGoToSleepHour invalid wakeHourMinuteDuration format',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String wakeHourMinuteDuration = '20.30';

          expect(
              () => dateTimeComputer.computeGoToSleepHour(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  wakeHourMinuteDurationStr: wakeHourMinuteDuration),
              throwsA(isA<FormatException>()));
        },
      );

      test(
        'computeGoToSleepHour valid params duration minutes > 59',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String wakeHourMinuteDuration = '20:61';
          final DateTime goToSleepHour = dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration);

          expect(goToSleepHour, DateTime(2022, 4, 16, 15, 16));
        },
      );

      test(
        'computeWakeUpDuration valid params',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String goToSleepDateTimeStr = '17-4-2022 8:45';
          final String goToSleepHour = dateTimeComputer.computeWakeUpDuration(
              wakeUpDateTimeStr: wakeUpDateTime,
              goToSleepDateTimeStr: goToSleepDateTimeStr);

          expect(goToSleepHour, '38:30');
        },
      );

      test(
        'computeWakeUpDuration valid params 1 minute duration',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String goToSleepDateTimeStr = '15-04-2022 18:16';
          final String goToSleepHour = dateTimeComputer.computeWakeUpDuration(
              wakeUpDateTimeStr: wakeUpDateTime,
              goToSleepDateTimeStr: goToSleepDateTimeStr);

          expect(goToSleepHour, '0:01');
        },
      );

      test(
        'computeWakeUpDuration valid params minute < 10',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String goToSleepDateTimeStr = '17-4-2022 8:17';
          final String goToSleepHour = dateTimeComputer.computeWakeUpDuration(
              wakeUpDateTimeStr: wakeUpDateTime,
              goToSleepDateTimeStr: goToSleepDateTimeStr);

          expect(goToSleepHour, '38:02');
        },
      );

      test(
        'computeWakeUpDuration invalid params goToSleepDateTimeStr before wakeUpDateTime',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String goToSleepDateTimeStr = '15-04-2022 18:14';

          expect(
              () => dateTimeComputer.computeWakeUpDuration(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  goToSleepDateTimeStr: goToSleepDateTimeStr),
              throwsA(predicate((e) =>
                  e is ArgumentError &&
                  e.message ==
                      'goToSleepDateTimeStr 15-04-2022 18:14 must be after wakeUpDateTimeStr 15-04-2022 18:15')));
        },
      );

      test(
        'computeWakeUpDuration invalid params goToSleepDateTimeStr equal to wakeUpDateTime',
        () {
          const String wakeUpDateTime = '15-04-2022 18:15';
          const String goToSleepDateTimeStr = '15-04-2022 18:15';

          expect(
              () => dateTimeComputer.computeWakeUpDuration(
                  wakeUpDateTimeStr: wakeUpDateTime,
                  goToSleepDateTimeStr: goToSleepDateTimeStr),
              throwsA(predicate((e) =>
                  e is ArgumentError &&
                  e.message ==
                      'goToSleepDateTimeStr 15-04-2022 18:15 must be after wakeUpDateTimeStr 15-04-2022 18:15')));
        },
      );
    },
  );
}
