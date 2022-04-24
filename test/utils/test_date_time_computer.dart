import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

import 'package:circa_plan/utils/date_time_computer.dart' as dtc;

void main() {
  final String localName = Platform.localeName;
  initializeDateFormatting(localName);
  group('DateTimeComputer.addDurationsToDateTime()', () {
    test('valid date time string', () {
      final DateTime? dateTime = dtc.DateTimeComputer.addDurationsToDateTime(
        dateTimeStr: '23-4-2022 18:00',
        posNegDurationStrLst: [
          '20:00',
          '8:00',
        ],
      );
      print(dateTime);
      //expect(dateTime, DateTime(2022, 4, 24, 22, 0));
    });
  });
}
