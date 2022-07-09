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
    },
  );
}
