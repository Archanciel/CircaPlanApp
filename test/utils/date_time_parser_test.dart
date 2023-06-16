import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DateTimeParser.parseDDMMDateTime()',
    () {
      test(
        'valid date time string',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('14-12 13:35');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, '14-12');
          expect(hourMinute, '13:35');
        },
      );

      test(
        'valid date time string shorter date and hour',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('4-2 3:35');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, '4-2');
          expect(hourMinute, '3:35');
        },
      );

      test(
        'invalid shorter date and valid hour',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('a4-2 3:35');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, null);
          expect(hourMinute, null);
        },
      );

      test(
        'valid date and invalid hour',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('14-2 3:u5');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, null);
          expect(hourMinute, null);
        },
      );

      test(
        'valid date and invalid minute',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('14-2 3:5');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, null);
          expect(hourMinute, null);
        },
      );

      test(
        'valid date no time',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('14-2 ');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, null);
          expect(hourMinute, null);
        },
      );

      test(
        'no date valid time',
        () {
          final List<String?> dateTimeComponentStrLst =
              DateTimeParser.parseDDMMDateTime('12:45');
          final String? dayMonth = dateTimeComponentStrLst[0];
          final String? hourMinute = dateTimeComponentStrLst[1];

          expect(dayMonth, null);
          expect(hourMinute, null);
        },
      );
    },
  );

  group(
    'DateTimeParser.parseTime()',
    () {
      test(
        'valid format time string',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('13:35');

          expect(hourMinute, '13:35');
        },
      );

      test(
        'invalid format time string',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('13-35');

          expect(hourMinute, null);
        },
      );

      test(
        'valid time string 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:35');

          expect(hourMinute, '3:35');
        },
      );

      test(
        'invalid time string 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:u5');

          expect(hourMinute, null);
        },
      );

      test(
        'invalid time string format 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3-05');

          expect(hourMinute, null);
        },
      );

      test(
        'invalid time string 1 digit minute',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('3:5');

          expect(hourMinute, null);
        },
      );

      test(
        'valid negative time string',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-13:35');

          expect(hourMinute, '-13:35');
        },
      );

      test(
        'invalid format negative time string',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-13-35');

          expect(hourMinute, null);
        },
      );

      test(
        'valid negative time string 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:35');

          expect(hourMinute, '-3:35');
        },
      );

      test(
        'invalid format negative time string 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3-05');

          expect(hourMinute, null);
        },
      );

      test(
        'invalid negative time string 1 digit hour',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:u5');

          expect(hourMinute, null);
        },
      );

      test(
        'invalid negative time string 1 digit minute',
        () {
          final String? hourMinute = DateTimeParser.parseHHMMTimeStr('-3:5');

          expect(hourMinute, null);
        },
      );

      test(
        'dd-mm date and time string',
        () {
          final String? hourMinute =
              DateTimeParser.parseHHMMTimeStr('14-12 13:35');

          expect(hourMinute, null);
        },
      );
      test(
        'dd-mm-yyyy date and time string',
        () {
          final String? hourMinute =
              DateTimeParser.parseHHMMTimeStr('14-12-2022 13:35');

          expect(hourMinute, null);
        },
      );

      test(
        '1 digit day and month date and time string',
        () {
          final String? hourMinute =
              DateTimeParser.parseHHMMTimeStr('4-2 13:35');

          expect(hourMinute, null);
        },
      );

      test(
        'invalid date and time string',
        () {
          final String? hourMinute =
              DateTimeParser.parseHHMMTimeStr('a4-2 13:35');

          expect(hourMinute, null);
        },
      );
    },
  );

  group(
    'DateTimeParser.parseHHmmDuration()',
    () {
      test(
        'valid hh:mm format time string',
        () {
          const String hourMinuteStr = '13:35';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: 13, minutes: 35));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'valid h:mm format time string',
        () {
          const String hourMinuteStr = '3:05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: 3, minutes: 5));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'valid 0:0m format time string',
        () {
          const String hourMinuteStr = '0:05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: 0, minutes: 5));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'invalid h:<letter>m format time string',
        () {
          const String hourMinuteStr = '3:u5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid h:m format time string',
        () {
          const String hourMinuteStr = '3:5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid h-0m format time string',
        () {
          const String hourMinuteStr = '3-05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid h-m format time string',
        () {
          const String hourMinuteStr = '3-5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'unacceptable valid dd-mm-yyyy hh:mmm format date time string',
        () {
          const String hourMinuteStr = '14-12-2022 13:35';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'unacceptable valid dd-mm hh:mmm format date time string',
        () {
          const String hourMinuteStr = '14-12 13:35';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'unacceptable invalid <letter>d-m hh:mmm format date time string',
        () {
          const String hourMinuteStr = 'a4-2 3:35';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'valid negative hh:mm format time string',
        () {
          const String hourMinuteStr = '-13:35';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -13, minutes: -35));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'valid negative h:mm format time string',
        () {
          const String hourMinuteStr = '-3:05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -3, minutes: -5));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'valid negative 0:0m format time string',
        () {
          const String hourMinuteStr = '-0:05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: 0, minutes: -5));
          expect(duration?.HHmm(), hourMinuteStr);
        },
      );

      test(
        'invalid negative h-mm format time string',
        () {
          const String hourMinuteStr = '-3-05';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid negative h:<letter>m format time string',
        () {
          const String hourMinuteStr = '-3:u5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid negative h:m format time string',
        () {
          const String hourMinuteStr = '-3:5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'invalid negative h-m format time string',
        () {
          const String hourMinuteStr = '-3-5';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, null);
          expect(duration?.HHmm(), null);
        },
      );

      test(
        'valid negative 0h:0m format time string',
        () {
          const String hourMinuteStr = '-05:06';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -5, minutes: -6));
          expect(duration?.HHmm(), '-5:06');
        },
      );

      test(
        'valid negative h:0m format time string',
        () {
          const String hourMinuteStr = '-5:06';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -5, minutes: -6));
          expect(duration?.HHmm(), '-5:06');
        },
      );

      test(
        'valid negative 00:0m format time string',
        () {
          const String hourMinuteStr = '-00:06';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: 0, minutes: -6));
          expect(duration?.HHmm(), '-0:06');
        },
      );

      test(
        'valid negative 0:0m format time string',
        () {
          const String hourMinuteStr = '-0:06';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -0, minutes: -6));
          expect(duration?.HHmm(), '-0:06');
        },
      );

      test(
        'valid negative hh:0m format time string',
        () {
          const String hourMinuteStr = '-15:06';
          final Duration? duration =
              DateTimeParser.parseHHMMDuration(hourMinuteStr);

          expect(duration, const Duration(hours: -15, minutes: -6));
          expect(duration?.HHmm(), '-15:06');
        },
      );
    },
  );
  group(
    'DateTimeParser.parseDDHHMMDuration()',
    () {
      test(
        'valid dd:hh:mm format nn days date time string',
        () {
          const String dayHourMinuteStr = '20:13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);

          expect(duration, const Duration(days: 20, hours: 13, minutes: 35));
          expect(duration?.ddHHmm(), dayHourMinuteStr);
        },
      );

      test(
        'valid dd:hh:mm format 0n days date time string',
        () {
          const String dayHourMinuteStr = '02:13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);

          expect(duration, const Duration(days: 2, hours: 13, minutes: 35));
          expect(duration?.ddHHmm(), dayHourMinuteStr);
        },
      );

      test(
        'valid dd:hh:mm format 0 days date time string',
        () {
          const String dayHourMinuteStr = '00:13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);

          expect(duration, const Duration(days: 0, hours: 13, minutes: 35));
          expect(duration?.ddHHmm(), dayHourMinuteStr);
        },
      );

      test(
        'valid negative dd:hh:mm format 0 days date time string',
        () {
          const String dayHourMinuteStr = '-00:13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);
          expect(duration.toString(), '-13:35:00.000000');
          expect(duration?.ddHHmm(), dayHourMinuteStr);
        },
      );

      test(
        'valid negative hh:mm format 0 days date time string',
        () {
          const String dayHourMinuteStr = '-13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);
          expect(duration, null);
        },
      );

      test(
        'valid positive hh:mm format 0 days date time string',
        () {
          const String dayHourMinuteStr = '13:35';
          final Duration? duration =
              DateTimeParser.parseDDHHMMDuration(dayHourMinuteStr);
          expect(duration, null);
        },
      );
    },
  );
  group(
    'DateTimeParser.parseDDHHMMorHHMMDuration()',
    () {
      test(
        'valid negative 00:mm time string',
        () {
          const String hourMinuteStr = '-00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          // expect(duration.toString(), '-0:05:00.000000'); Dart bug !
          expect(duration?.ddHHmm(), '-00:00:05');
          expect(duration?.HHmm(), '-0:05');
        },
      );

      test(
        'valid negative 0:mm time string',
        () {
          const String hourMinuteStr = '-0:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-00:00:05');
          expect(duration?.HHmm(), '-0:05');
        },
      );

      test(
        'valid negative 01:mm time string',
        () {
          const String hourMinuteStr = '-01:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-00:01:05');
          expect(duration?.HHmm(), '-1:05');
        },
      );

      test(
        'valid negative 1:mm time string',
        () {
          const String hourMinuteStr = '-1:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-00:01:05');
          expect(duration?.HHmm(), '-1:05');
        },
      );

      test(
        'valid negative 11:mm time string',
        () {
          const String hourMinuteStr = '-11:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-00:11:05');
          expect(duration?.HHmm(), '-11:05');
        },
      );

      test(
        'valid negative 00:00:mm time string',
        () {
          const String hourMinuteStr = '-00:00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          // expect(duration.toString(), '-0:05:00.000000'); Dart bug !
          expect(duration?.ddHHmm(), '-00:00:05');
          expect(duration?.HHmm(), '-0:05');
        },
      );

      test(
        'valid negative 0:00:mm time string',
        () {
          const String hourMinuteStr = '-0:00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-00:00:05');
          expect(duration?.HHmm(), '-0:05');
        },
      );

      test(
        'valid negative 01:00:mm time string',
        () {
          const String hourMinuteStr = '-01:00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-01:00:05');
          expect(duration?.HHmm(), '-24:05');
        },
      );

      test(
        'valid negative 1:00:mm time string',
        () {
          const String hourMinuteStr = '-1:00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-01:00:05');
          expect(duration?.HHmm(), '-24:05');
        },
      );

      test(
        'valid negative 11:00:mm time string',
        () {
          const String hourMinuteStr = '-11:00:05';
          final Duration? duration =
              DateTimeParser.parseDDHHMMorHHMMDuration(hourMinuteStr);
          //       expect(duration.toString(), '-0:05:00.000000');
          expect(duration?.ddHHmm(), '-11:00:05');
          expect(duration?.HHmm(), '-264:05');
        },
      );
    },
  );
  group(
    'DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr()',
    () {
      test(
        'valid date time string',
        () {
          final String? englishFormatDdateTimeStr =
              DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                  frenchFormatDateTimeStr: '14-12-2022 13:35');

          expect(englishFormatDdateTimeStr, '2022-12-14 13:35');
        },
      );
      test(
        'invalid date time string',
        () {
          final String? englishFormatDdateTimeStr =
              DateTimeParser.convertFrenchFormatToEnglishFormatDateTimeStr(
                  frenchFormatDateTimeStr: '14-12_022 13:35');

          expect(englishFormatDdateTimeStr, null);
        },
      );
    },
  );
  group(
    'DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr()',
    () {
      test(
        'valid date time string',
        () {
          final String? frenchFormatDdateTimeStr =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: '2022-12-14 13:35');

          expect(frenchFormatDdateTimeStr, '14-12-2022 13:35');
        },
      );
      test(
        'invalid date time string',
        () {
          final String? frenchFormatDdateTimeStr =
              DateTimeParser.convertEnglishFormatToFrenchFormatDateTimeStr(
                  englishFormatDateTimeStr: '202212-14 13:35');

          expect(frenchFormatDdateTimeStr, null);
        },
      );
    },
  );
  group(
    'DateTimeParser.parseAllHHMMTimeStr()',
    () {
      test(
        'positive times string',
        () {
          const String timeStr = '13:35 3:05,0:05, 0:05,3:u5 3:5, 3-05 3-5';

          List<String> parsedTimeStrLst =
              DateTimeParser.parseAllHHMMTimeStr(timeStr);

          expect(parsedTimeStrLst, ['13:35', '3:05', '0:05', '0:05']);
        },
      );
      test(
        'negative times string',
        () {
          const String negativeTimeStr =
              '-13:35 -3:05,-0:05,-3-05 -3:u5, -3:5 -3-5';

          List<String> parsedNegTimeStrLst =
              DateTimeParser.parseAllHHMMTimeStr(negativeTimeStr);

          expect(parsedNegTimeStrLst, ['-13:35', '-3:05', '-0:05']);
        },
      );
    },
  );
  group(
    'DateTimeParser.parseAllIntOrHHMMTimeStr()',
    () {
      test(
        'positive valid times string',
        () {
          const String timeStr = '10 2 13:35, 5,3 3:05,0:05, 0:05';

          List<String> parsedTimeStrLst =
              DateTimeParser.parseAllIntOrHHMMTimeStr(timeStr);

          expect(parsedTimeStrLst, [
            '10:00',
            '2:00',
            '13:35',
            '5:00',
            '3:00',
            '3:05',
            '0:05',
            '0:05'
          ]);
        },
      );
      test(
        'negative valid times string',
        () {
          const String timeStr = '-10 -2 -13:35, 5,-3 3:05,0:05, -0:05';

          List<String> parsedTimeStrLst =
              DateTimeParser.parseAllIntOrHHMMTimeStr(timeStr);

          expect(parsedTimeStrLst, [
            '-10:00',
            '-2:00',
            '-13:35',
            '5:00',
            '-3:00',
            '3:05',
            '0:05',
            '-0:05'
          ]);
        },
      );
      test(
        'positive valid and invalid times string',
        () {
          const String timeStr =
              '10 2 13:35, 5,3 3:05,0:05, 0:05,3:u5 3:5, 3-05 3-5';

          List<String> parsedTimeStrLst =
              DateTimeParser.parseAllIntOrHHMMTimeStr(timeStr);

          expect(parsedTimeStrLst, [
            '10:00',
            '2:00',
            '13:35',
            '5:00',
            '3:00',
            '3:05',
            '0:05',
            '0:05',
            '3:u5',
            '3:50',
            '3-05',
            '3-5'
          ]);
        },
      );
      test(
        'negative valid and invalid times string',
        () {
          const String negativeTimeStr =
              '-13:35 -3:05,-0:05,-3-05 -3:u5, -3:5 -3-5';

          List<String> parsedNegTimeStrLst =
              DateTimeParser.parseAllIntOrHHMMTimeStr(negativeTimeStr);

          expect(parsedNegTimeStrLst,
              ['-13:35', '-3:05', '-0:05', '-3-05', '-3:u5', '-3:50', '-3-5']);
        },
      );
      test(
        'rounding date time to next hour',
        () {
          final DateTime dateTime = DateTime(2021, 1, 1, 13, 35);
          final DateTime roundedDateTime =
              DateTimeParser.roundDateTimeToHour(dateTime);
          expect(roundedDateTime, DateTime(2021, 1, 1, 14, 0));
        },
      );
      test(
        'rounding date time to next hour 30 minutes',
        () {
          final DateTime dateTime = DateTime(2021, 1, 1, 13, 30);
          final DateTime roundedDateTime =
              DateTimeParser.roundDateTimeToHour(dateTime);
          expect(roundedDateTime, DateTime(2021, 1, 1, 14, 0));
        },
      );
      test(
        'rounding date time to hour',
        () {
          final DateTime dateTime = DateTime(2021, 1, 1, 13, 25);
          final DateTime roundedDateTime =
              DateTimeParser.roundDateTimeToHour(dateTime);
          expect(roundedDateTime, DateTime(2021, 1, 1, 13, 0));
        },
      );
    },
  );
}
