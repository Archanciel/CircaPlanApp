import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  const List<String> dateTimeStrLst = [
    '14-12 13:35',
    '4-2 3:05',
    'a4-2 3:05',
    '14-2 3:u5',
    '14-2 3:5',
  ];

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
  });
}
