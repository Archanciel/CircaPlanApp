import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  group('DateTimeComputer', () {
    test('parseDateTime valid date time string', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('14-12 13:35');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, '14-12');
      expect(hourMinute, '13:35');
    });

    test('parseDateTime valid date time string shorter date and hour', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('4-2 3:35');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, '4-2');
      expect(hourMinute, '3:35');
    });

    test('parseDateTime invalid shorter date and valid hour', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('a4-2 3:35');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('parseDateTime valid date and invalid hour', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('14-2 3:u5');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('parseDateTime valid date and invalid minute', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('14-2 3:5');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('parseDateTime valid date no time', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('14-2 ');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('parseDateTime no date valid time', () {
      List<String?> dateTimeComponentStrLst =
          DateTimeParser.parseDateTime('12:45');
      String? dayMonth = dateTimeComponentStrLst[0];
      String? hourMinute = dateTimeComponentStrLst[1];

      expect(dayMonth, null);
      expect(hourMinute, null);
    });

    test('parseTime valid time string', () {
      String? hourMinute = DateTimeParser.parseTime('13:35');

      expect(hourMinute, '13:35');
    });

    test('parseTime valid time string 1 digit hour', () {
      String? hourMinute = DateTimeParser.parseTime('3:35');

      expect(hourMinute, '3:35');
    });

    test('parseTime invalid time string 1 digit hour', () {
      String? hourMinute = DateTimeParser.parseTime('3:u5');

      expect(hourMinute, null);
    });

    test('parseTime invalid time string 1 digit minute', () {
      String? hourMinute = DateTimeParser.parseTime('3:5');

      expect(hourMinute, null);
    });

    test('parseTime date and time string', () {
      String? hourMinute = DateTimeParser.parseTime('14-12 13:35');

      expect(hourMinute, null);
    });

    test('parseTime 1 digit day and month date and time string', () {
      String? hourMinute = DateTimeParser.parseTime('4-2 13:35');

      expect(hourMinute, null);
    });

    test('parseTime invalid date and time string', () {
      String? hourMinute = DateTimeParser.parseTime('a4-2 13:35');

      expect(hourMinute, null);
    });

  });
}
