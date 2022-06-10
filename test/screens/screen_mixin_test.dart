import 'package:test/test.dart';

import 'package:circa_plan/screens/screen_mixin.dart';

class TestClassWithScreenMixin with ScreenMixin {}

void main() {
  final TestClassWithScreenMixin testClassWithSreenMixin = TestClassWithScreenMixin();

  group('Test ScreenMixin', () {
    test('buildAppDateTimeStrList several date time str', () {
      final Map<String, dynamic> transferDataMap = {};

      transferDataMap['calcSlDurNewDateTimeStr'] = '01-06-2022 23:42';
      transferDataMap['calcSlDurLastWakeUpTimeStr'] = '02-06-2022 03:42';
      transferDataMap['calcSlDurPreviousDateTimeStr'] = '02-06-2022 03:42';
      transferDataMap['calcSlDurBeforePreviousDateTimeStr'] =
          '02-06-2022 02:42';
      transferDataMap['calcSlDurCurrSleepDurationStr'] = '04:00';
      transferDataMap['calcSlDurCurrWakeUpDurationStr'] = '00:48';
      transferDataMap['calcSlDurCurrTotalDurationStr'] = '04:48';
      transferDataMap['calcSlDurSleepTimeStrHistory'] = [
        '01-06-2022 23:42',
        '04:00',
      ];
      transferDataMap['firstTimeStr'] = '00:03:45';
      transferDataMap['secondTimeStr'] = '00:00:45';
      transferDataMap['dtDiffEndDateTimeStr'] = '02-06-2022 06:42';
      transferDataMap['dtDiffDurationStr'] = '02:53';

      List<String> actualDateTimeStrLst = testClassWithSreenMixin.buildAppDateTimeStrList(transferDataMap: transferDataMap);
      List<String> expectedDateTimeStrLst = [
        '01-06-2022 23:42',
        '02-06-2022 03:42',
        '02-06-2022 06:42',
      ];
      
      expect(actualDateTimeStrLst, expectedDateTimeStrLst);
    });
  });
}
