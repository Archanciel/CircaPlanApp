import 'package:test/test.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

class TestClassWithScreenMixin with ScreenMixin {}

void main() {
  final TestClassWithScreenMixin testClassWithSreenMixin =
      TestClassWithScreenMixin();

  group('Test ScreenMixin', () {
    final Map<String, dynamic> transferDataMapRegular = {};

    transferDataMapRegular['calcSlDurNewDateTimeStr'] = '01-06-2022 23:42';
    transferDataMapRegular['calcSlDurLastWakeUpTimeStr'] = '02-06-2022 02:42';
    transferDataMapRegular['calcSlDurPreviousDateTimeStr'] = '03-06-2022 03:42';
    transferDataMapRegular['calcSlDurBeforePreviousDateTimeStr'] =
        '02-06-2022 02:42';
    transferDataMapRegular['calcSlDurCurrSleepDurationStr'] = '04:00';
    transferDataMapRegular['calcSlDurCurrWakeUpDurationStr'] = '00:48';
    transferDataMapRegular['calcSlDurCurrTotalDurationStr'] = '04:48';
    transferDataMapRegular['calcSlDurSleepTimeStrHistory'] = [
      '01-06-2022 23:42',
      '04:00',
    ];
    transferDataMapRegular['addDurStartDateTimeStr'] = '03-06-2022 03:42';

    transferDataMapRegular['firstTimeStr'] = '00:03:45';
    transferDataMapRegular['secondTimeStr'] = '00:00:45';
    transferDataMapRegular['dtDiffEndDateTimeStr'] = '03-06-2022 06:42';
    transferDataMapRegular['dtDiffDurationStr'] = '02:53';

    test(
        'buildSortedAppDateTimeStrList several and double date time str most late first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapRegular, mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [
        '01-06-2022 23:42',
        '02-06-2022 02:42',
        '03-06-2022 03:42',
        '03-06-2022 06:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test(
        'buildSortedAppDateTimeStrList several and double date time str most recent first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapRegular, mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [
        '03-06-2022 06:42',
        '03-06-2022 03:42',
        '02-06-2022 02:42',
        '01-06-2022 23:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    final Map<String, dynamic> transferDataMapTimeOnly = {};

    transferDataMapTimeOnly['calcSlDurCurrSleepDurationStr'] = '04:00';
    transferDataMapTimeOnly['calcSlDurCurrWakeUpDurationStr'] = '00:48';
    transferDataMapTimeOnly['calcSlDurCurrTotalDurationStr'] = '04:48';
    transferDataMapTimeOnly['firstTimeStr'] = '00:03:45';
    transferDataMapTimeOnly['secondTimeStr'] = '00:00:45';

    test('buildSortedAppDateTimeStrList no date time str most late first', () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapTimeOnly, mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test('buildSortedAppDateTimeStrList no date time str most recent first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapTimeOnly, mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    final Map<String, dynamic> transferDataMapEmpty = {};

    test('buildSortedAppDateTimeStrList map empty most late first', () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapEmpty, mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test('buildSortedAppDateTimeStrList map empty most recent first', () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapEmpty, mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    final Map<String, dynamic> transferDataMapOneDateTime = {};

    transferDataMapOneDateTime['calcSlDurNewDateTimeStr'] = '01-06-2022 23:42';

    test('buildSortedAppDateTimeStrList one date time str most late first', () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapOneDateTime,
              mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [
        '01-06-2022 23:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test('buildSortedAppDateTimeStrList one date time str most recent first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapOneDateTime,
              mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [
        '01-06-2022 23:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    final Map<String, dynamic> transferDataMapInvalidFormat = {};

    // entry with invalid date format
    transferDataMapInvalidFormat['calcSlDurNewDateTimeStr'] =
        '01/06/2022 23:42';

    // entry with invalid date format
    transferDataMapInvalidFormat['calcSlDurLastWakeUpTimeStr'] = '02-06 02:42';

    // entry with invalid date format
    transferDataMapInvalidFormat['calcSlDurPreviousDateTimeStr'] =
        '06-2022 03:42';

    // entry with invalid date format
    transferDataMapInvalidFormat['calcSlDurBeforePreviousDateTimeStr'] =
        '02-06 02:42';
    transferDataMapInvalidFormat['calcSlDurCurrSleepDurationStr'] = '04:00';
    transferDataMapInvalidFormat['calcSlDurCurrWakeUpDurationStr'] = '00:48';
    transferDataMapInvalidFormat['calcSlDurCurrTotalDurationStr'] = '04:48';
    transferDataMapInvalidFormat['calcSlDurSleepTimeStrHistory'] = [
      '01-06-2022 23:42',
      '04:00',
    ];
    transferDataMapInvalidFormat['addDurStartDateTimeStr'] = '03-06-2022 03:42';

    transferDataMapInvalidFormat['firstTimeStr'] = '00:03:45';
    transferDataMapInvalidFormat['secondTimeStr'] = '00:00:45';
    transferDataMapInvalidFormat['dtDiffEndDateTimeStr'] = '03-06-2022 06:42';

    // entry with invalid time format
    transferDataMapInvalidFormat['dtDiffDurationStr'] = '02:53';

    // entry with invalid time format
    transferDataMapInvalidFormat['dtDiffStartDateTimeStr'] = '04-06-2022 06-22';

    test(
        'buildSortedAppDateTimeStrList several and double date time str most late first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapInvalidFormat,
              mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [
        '03-06-2022 03:42',
        '03-06-2022 06:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test(
        'buildSortedAppDateTimeStrList several and double date time str most recent first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapInvalidFormat,
              mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [
        '03-06-2022 06:42',
        '03-06-2022 03:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    final Map<String, dynamic> transferDataMapEnglishAndFrenchDateTime = {};

    transferDataMapEnglishAndFrenchDateTime['calcSlDurNewDateTimeStr'] =
        '01-06-2022 23:42';
    transferDataMapEnglishAndFrenchDateTime['dtDiffEndDateTimeStr'] =
        '2022-06-11 22:30';
    transferDataMapEnglishAndFrenchDateTime['calcSlDurPreviousDateTimeStr'] =
        '02-06-2022 23:42';
    transferDataMapEnglishAndFrenchDateTime['dtDiffStartDateTimeStr'] =
        '2022-06-10 00:30';

    test('buildSortedAppDateTimeStrList english (DateTimePicker field) and french format date time str most late first', () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapEnglishAndFrenchDateTime,
              mostRecentFirst: false);
      List<String> expectedDateTimeStrLst = [
        '01-06-2022 23:42',
        '02-06-2022 23:42',
        '10-06-2022 00:30',
        '11-06-2022 22:30',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });

    test('buildSortedAppDateTimeStrList english (DateTimePicker field) and french format date time str most recent first',
        () {
      List<String> actualDateTimeStrLst =
          testClassWithSreenMixin.buildSortedAppDateTimeStrList(
              transferDataMap: transferDataMapEnglishAndFrenchDateTime,
              mostRecentFirst: true);
      List<String> expectedDateTimeStrLst = [
        '11-06-2022 22:30',
        '10-06-2022 00:30',
        '02-06-2022 23:42',
        '01-06-2022 23:42',
      ];

      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });
  });
}
