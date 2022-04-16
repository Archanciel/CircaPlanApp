import 'package:circa_plan/services/date_time_computer.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeComputer', () {
    final DateTimeComputer dateTimeComputer = DateTimeComputer();

    test('computeGoToSleepHour valid params', () {
      final String wakeUpDateTime = '15-04-2022 18:15';
      final String wakeHourMinuteDuration = '20:30';
      final DateTime goToSleepHour = dateTimeComputer.computeGoToSleepHour(
          wakeUpDateTimeStr: wakeUpDateTime,
          wakeHourMinuteDurationStr: wakeHourMinuteDuration);

      expect(goToSleepHour, DateTime(2022, 4, 16, 14, 45));
    });

    test('computeGoToSleepHour invalid wakeUpDateTime value', () {
      final String wakeUpDateTime = '31-04-2022 18:15';
      final String wakeHourMinuteDuration = '20:30';

      expect(
          () => dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration),
          throwsA(isA<FormatException>()));
    });

    test('computeGoToSleepHour invalid wakeUp date format', () {
      final String wakeUpDateTime = '30/04/2022 18:15';
      final String wakeHourMinuteDuration = '20:30';

      expect(
              () => dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration),
          throwsA(isA<FormatException>()));
    });

    test('computeGoToSleepHour invalid wakeUp time format', () {
      final String wakeUpDateTime = '31-04-2022 18-15';
      final String wakeHourMinuteDuration = '20:30';

      expect(
              () => dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration),
          throwsA(isA<FormatException>()));
    });

    test('computeGoToSleepHour invalid wakeHourMinuteDuration format', () {
      final String wakeUpDateTime = '15-04-2022 18:15';
      final String wakeHourMinuteDuration = '20.30';

      expect(
              () => dateTimeComputer.computeGoToSleepHour(
              wakeUpDateTimeStr: wakeUpDateTime,
              wakeHourMinuteDurationStr: wakeHourMinuteDuration),
          throwsA(isA<FormatException>()));
    });

    test('computeGoToSleepHour valid params duration minutes > 59', () {
      final String wakeUpDateTime = '15-04-2022 18:15';
      final String wakeHourMinuteDuration = '20:61';
      final DateTime goToSleepHour = dateTimeComputer.computeGoToSleepHour(
          wakeUpDateTimeStr: wakeUpDateTime,
          wakeHourMinuteDurationStr: wakeHourMinuteDuration);

      expect(goToSleepHour, DateTime(2022, 4, 16, 15, 16));
    });
  });
}
