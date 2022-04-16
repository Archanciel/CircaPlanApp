import 'package:circa_plan/services/date_time_computer.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeComputer', () {
    final DateTimeComputer dateTimeComputer = DateTimeComputer();

    test('computeGoToSleepHour', () {
      final String wakeUpDateTime = '15-04-2022 18:15';
      final String wakeHourMinuteDuration = '20:30';
      final DateTime goToSleepHour = dateTimeComputer.computeGoToSleepHour(
          wakeUpDateTimeStr: wakeUpDateTime,
          wakeHourMinuteDurationStr: wakeHourMinuteDuration);

      expect(goToSleepHour, DateTime(2022, 4, 16, 14, 45));
    });
  });
}
