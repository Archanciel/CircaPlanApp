import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeParser.parseDDMMDateTime()', () {
    test('valid date time string', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('14-12 13:35');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, '14-12');
      expect(hourMinute, '13:35');
    });

    test('valid date time string shorter date and hour', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('4-2 3:35');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, '4-2');
      expect(hourMinute, '3:35');
    });

    test('invalid shorter date and valid hour', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('a4-2 3:35');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('valid date and invalid hour', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('14-2 3:u5');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('valid date and invalid minute', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('14-2 3:5');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('valid date no time', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('14-2 ');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('no date valid time', () {
      final List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDDMMDateTime('12:45');
      final String? dayMonth = dateTimeComponentStrLst[0];
      final String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });
  });

  group('DateTimeParser.parseTime()', () {
    test('valid format time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('13:35');

      expect(hourMinute, '13:35');
    });

    test('invalid format time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('13-35');

      expect(hourMinute, null);
    });

    test('valid time string 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:35');

      expect(hourMinute, '3:35');
    });

    test('invalid time string 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:u5');

      expect(hourMinute, null);
    });

    test('invalid time string format 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3-05');

      expect(hourMinute, null);
    });

    test('invalid time string 1 digit minute', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:5');

      expect(hourMinute, null);
    });

    test('valid negative time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-13:35');

      expect(hourMinute, '-13:35');
    });

    test('invalid format negative time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-13-35');

      expect(hourMinute, null);
    });

    test('valid negative time string 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:35');

      expect(hourMinute, '-3:35');
    });

    test('invalid format negative time string 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3-05');

      expect(hourMinute, null);
    });

    test('invalid negative time string 1 digit hour', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:u5');

      expect(hourMinute, null);
    });

    test('invalid negative time string 1 digit minute', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:5');

      expect(hourMinute, null);
    });

    test('date and time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('14-12 13:35');

      expect(hourMinute, null);
    });

    test('1 digit day and month date and time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('4-2 13:35');

      expect(hourMinute, null);
    });

    test('invalid date and time string', () {
      final String? hourMinute = DateTimeParser.parseHHMMTimeStr('a4-2 13:35');

      expect(hourMinute, null);
    });
  });

  group('DateTimeParser.parseHHmmDuration()', () {
    test('valid hh:mm format time string', () {
      const String hourMinuteStr = '13:35';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: 13, minutes: 35));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('valid h:mm format time string', () {
      const String hourMinuteStr = '3:05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: 3, minutes: 5));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('valid 0:0m format time string', () {
      const String hourMinuteStr = '0:05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: 0, minutes: 5));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('invalid h:<letter>m format time string', () {
      const String hourMinuteStr = '3:u5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid h:m format time string', () {
      const String hourMinuteStr = '3:5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid h-0m format time string', () {
      const String hourMinuteStr = '3-05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid h-m format time string', () {
      const String hourMinuteStr = '3-5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('unacceptable valid dd-mm-yyyy hh:mmm format date time string', () {
      const String hourMinuteStr = '14-12-2022 13:35';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('unacceptable valid dd-mm hh:mmm format date time string', () {
      const String hourMinuteStr = '14-12 13:35';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('unacceptable invalid <letter>d-m hh:mmm format date time string', () {
      const String hourMinuteStr = 'a4-2 3:35';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('valid negative hh:mm format time string', () {
      const String hourMinuteStr = '-13:35';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: -13, minutes: -35));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('valid negative h:mm format time string', () {
      const String hourMinuteStr = '-3:05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: -3, minutes: -5));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('valid negative 0:0m format time string', () {
      const String hourMinuteStr = '-0:05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, const Duration(hours: 0, minutes: -5));
      expect(duration?.HHmm(), hourMinuteStr);
    });

    test('invalid negative h-mm format time string', () {
      const String hourMinuteStr = '-3-05';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid negative h:<letter>m format time string', () {
      const String hourMinuteStr = '-3:u5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid negative h:m format time string', () {
      const String hourMinuteStr = '-3:5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });

    test('invalid negative h-m format time string', () {
      const String hourMinuteStr = '-3-5';
      final Duration? duration =
          DateTimeParser.parseHHmmDuration(hourMinuteStr);

      expect(duration, null);
      expect(duration?.HHmm(), null);
    });
  });
}