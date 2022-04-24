import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

import 'package:circa_plan/utils/date_time_computer.dart' as dtc;

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);

  group('DateTimeComputer.addDurationsToDateTime()', () {
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
