import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

import 'package:circa_plan/utils/date_time_computer.dart' as dtc;

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);

  group('DateTimeComputer.addDurationsToDateTime()', () {
    test('valid date time string + 1 durations', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '15-4-2022 18:15',
        posNegDurationStrLst: [
          '20:00',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 16, 14, 15));
    });

    test('valid date time string + 2 durations', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '23-4-2022 18:00',
        posNegDurationStrLst: [
          '20:00',
          '8:00',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 24, 22, 0));
    });

    test('valid date time string + 2 durations result not 0 minute', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '23-4-2022 18:00',
        posNegDurationStrLst: [
          '20:00',
          '3:16',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 24, 17, 16));
    });

    test('valid date time string + 3 durations 2 negatives', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '16-4-2022 15:30',
        posNegDurationStrLst: [
          '-10:30',
          '-3:45',
          '0:15',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 16, 1, 30));
    });

    test('valid date time string + 2 durations 1 negative', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '16-4-2022 15:30',
        posNegDurationStrLst: [
          '4:00',
          '-8:15',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 16, 11, 15));
    });

    test('valid date time string + 1 durations min neg duration', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '16-4-2022 15:30',
        posNegDurationStrLst: [
          '-0:01',
        ],
      );
      expect(dateTime, DateTime(2022, 4, 16, 15, 29));
    });

    test('valid date time string + 3 durations min 2 neg duration', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '16-4-2022 15:30',
        posNegDurationStrLst: [
          '-0:01',
          '1:5',
          '-0:02',
        ],
      );
      expect(dateTime, DateTime(2022, 4, 16, 15, 27));
    });

    test('invalid date time string + 2 valid durations', () {
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
    });

    test('valid date time string + 1 invalid duration', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '23-4-2022 18:00',
        posNegDurationStrLst: [
          '2a:00',
        ],
      );

      expect(dateTime, DateTime(2022, 4, 23, 18, 0));
    });
  });
}
