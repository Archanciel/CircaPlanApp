import 'dart:io';

import 'package:circa_plan/utils/utility.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Utility()',
    () {
      test(
        'renameFile()',
        () {
          String notExistfilePathNameStr = 'c:\\temp\\circadian.json';

          File? renamedFile = Utility.renameFile(
              filePathNameStr: notExistfilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          expect(null, renamedFile);

          String originalFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian.json';

          renamedFile = Utility.renameFile(
              filePathNameStr: originalFilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          String renamedFilePathNameStr =
              'c:\\temp\\CircadianData\\2022-08-07 02.30.json';

          expect(renamedFilePathNameStr, renamedFile!.path);

          renamedFile = Utility.renameFile(
              filePathNameStr: renamedFilePathNameStr,
              newFileNameStr: 'circadian.json');

          expect(originalFilePathNameStr, renamedFile!.path);
        },
      );

      test(
        'formatJsonFileContent()',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian.json';
          String printableJsonFileContent = await Utility.formatJsonFileContent(
              jsonFilePathName: jsonFilePathNameStr);
          String expectedFormattedJsonFileCont = '''
{
  "addDurationToDateTimeData": {
    "screenDataType": 0,
    "addDurationStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationIconType": 0,
    "firstAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "firstAddDurationDurationStr": "00:50",
    "firstAddDurationEndDateTimeStr": "12-07-2022 16:50",
    "secondDurationIconType": 1,
    "secondAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "secondAddDurationDurationStr": "02:00",
    "secondAddDurationEndDateTimeStr": "12-07-2022 14:00",
    "thirdDurationIconType": 1,
    "thirdAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "thirdAddDurationDurationStr": "00:00",
    "thirdAddDurationEndDateTimeStr": "12-07-2022 16:00"
  },
  "calculateSleepDurationData": {
    "screenDataType": 1,
    "status": 1,
    "sleepDurationNewDateTimeStr": "14-07-2022 13:09",
    "sleepDurationPreviousDateTimeStr": "14-07-2022 13:13",
    "sleepDurationBeforePreviousDateTimeStr": "14-07-2022 13:12",
    "sleepDurationStr": "12:36",
    "wakeUpDurationStr": "0:02",
    "totalDurationStr": "12:38",
    "sleepDurationPercentStr": "99.74 %",
    "wakeUpDurationPercentStr": "0.26 %",
    "totalDurationPercentStr": "100 %",
    "sleepPrevDayTotalPercentStr": "79.74 %",
    "wakeUpPrevDayTotalPercentStr": "1.26 %",
    "totalPrevDayTotalPercentStr": "81 %",
    "sleepHistoryDateTimeStrLst": [
      "10_07_2022 00:58",
      "05:35",
      "04:00"
    ],
    "wakeUpHistoryDateTimeStrLst": [
      "10_07_2022 05:58",
      "00:35",
      "01:00"
    ]
  },
  "dateTimeDifferenceDurationData": {
    "screenDataType": 2,
    "dateTimeDifferenceStartDateTimeStr": "2022-07-13 16:09",
    "dateTimeDifferenceEndDateTimeStr": "2022-07-14 16:09:42.390753",
    "dateTimeDifferenceDurationStr": "24:00",
    "dateTimeDifferenceAddTimeStr": "1:00",
    "dateTimeDifferenceFinalDurationStr": "25:00",
    "dateTimeDurationPercentStr": "70 %"
  },
  "timeCalculatorData": {
    "screenDataType": 3,
    "timeCalculatorFirstTimeStr": "00:10:00",
    "timeCalculatorSecondTimeStr": "00:05:00",
    "timeCalculatorResultTimeStr": "00:15:00"
  },
  "currentScreenStateInstance": null,
  "calcSlDurStatus": null,
  "firstDurationIconData": null,
  "firstDurationIconColor": null,
  "secondDurationIconData": null,
  "secondDurationIconColor": null,
  "thirdDurationIconData": null,
  "thirdDurationIconColor": null,
  "firstDurationTextColor": null,
  "secondDurationTextColor": null,
  "thirdDurationTextColor": null
}''';
          expect(printableJsonFileContent, expectedFormattedJsonFileCont);
        },
      );
      test(
        'formatMapContent()',
        () async {
          Map<String, dynamic> map = {
            'one': 1,
            'doubleTwo': 2.2,
            'hello': 'Hello world !',
            'sub map': {'waouh': 111, 'grr': 37},
            'coucou': 'Coucou world !',
          };

          String printableFormattedMap =
              await Utility.formatMapContent(map: map);

          String expectedFormattedMap = '''
{
  "one": 1,
  "doubleTwo": 2.2,
  "hello": "Hello world !",
  "sub map": {
    "waouh": 111,
    "grr": 37
  },
  "coucou": "Coucou world !",
  "currentScreenStateInstance": null,
  "calcSlDurStatus": null,
  "firstDurationIconData": null,
  "firstDurationIconColor": null,
  "secondDurationIconData": null,
  "secondDurationIconColor": null,
  "thirdDurationIconData": null,
  "thirdDurationIconColor": null,
  "firstDurationTextColor": null,
  "secondDurationTextColor": null,
  "thirdDurationTextColor": null
}''';
          expect(expectedFormattedMap, printableFormattedMap);
        },
      );

      test(
        'formatJsonString()',
        () {
          String jsonStr =
              '{"addDurationToDateTimeData": {"screenDataType": 0, "addDurationStartDateTimeStr": "2022-07-12 16:00:26.486627", "firstDurationIconType": 0, "firstAddDurationStartDateTimeStr": "12-07-2022 16:00", "firstAddDurationDurationStr": "00:50", "firstAddDurationEndDateTimeStr": "12-07-2022 16:50", "secondDurationIconType": 1, "secondAddDurationStartDateTimeStr": "12-07-2022 16:00", "secondAddDurationDurationStr": "02:00", "secondAddDurationEndDateTimeStr": "12-07-2022 14:00", "thirdDurationIconType": 1, "thirdAddDurationStartDateTimeStr": "12-07-2022 16:00", "thirdAddDurationDurationStr": "00:00", "thirdAddDurationEndDateTimeStr": "12-07-2022 16:00"}, "calculateSleepDurationData": {"screenDataType": 1, "status": 1, "sleepDurationNewDateTimeStr": "14-07-2022 13:09", "sleepDurationPreviousDateTimeStr": "14-07-2022 13:13", "sleepDurationBeforePreviousDateTimeStr": "14-07-2022 13:12", "sleepDurationStr": "12:36", "wakeUpDurationStr": "0:02", "totalDurationStr": "12:38", "sleepDurationPercentStr": "99.74 %", "wakeUpDurationPercentStr": "0.26 %", "totalDurationPercentStr": "100 %", "sleepHistoryDateTimeStrLst": ["10_07_2022 00:58", "05:35", "04:00"], "wakeUpHistoryDateTimeStrLst": ["10_07_2022 05:58", "00:35", "01:00"]}, "dateTimeDifferenceDurationData": {"screenDataType": 2, "dateTimeDifferenceStartDateTimeStr": "2022-07-13 16:09", "dateTimeDifferenceEndDateTimeStr": "2022-07-14 16:09:42.390753", "dateTimeDifferenceDurationStr": "24:00", "dateTimeDifferenceAddTimeStr": "1:00", "dateTimeDifferenceFinalDurationStr": "25:00"}, "timeCalculatorData": {"screenDataType": 3, "timeCalculatorFirstTimeStr": "00:10:00", "timeCalculatorSecondTimeStr": "00:05:00", "timeCalculatorResultTimeStr": "00:15:00"}}';
          String printableJsonString =
              Utility.formatJsonString(jsonString: jsonStr);

          String expectedFormattedJsonString = '''
{
  "addDurationToDateTimeData": {
    "screenDataType": 0,
    "addDurationStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationIconType": 0,
    "firstAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "firstAddDurationDurationStr": "00:50",
    "firstAddDurationEndDateTimeStr": "12-07-2022 16:50",
    "secondDurationIconType": 1,
    "secondAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "secondAddDurationDurationStr": "02:00",
    "secondAddDurationEndDateTimeStr": "12-07-2022 14:00",
    "thirdDurationIconType": 1,
    "thirdAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "thirdAddDurationDurationStr": "00:00",
    "thirdAddDurationEndDateTimeStr": "12-07-2022 16:00"
  },
  "calculateSleepDurationData": {
    "screenDataType": 1,
    "status": 1,
    "sleepDurationNewDateTimeStr": "14-07-2022 13:09",
    "sleepDurationPreviousDateTimeStr": "14-07-2022 13:13",
    "sleepDurationBeforePreviousDateTimeStr": "14-07-2022 13:12",
    "sleepDurationStr": "12:36",
    "wakeUpDurationStr": "0:02",
    "totalDurationStr": "12:38",
    "sleepDurationPercentStr": "99.74 %",
    "wakeUpDurationPercentStr": "0.26 %",
    "totalDurationPercentStr": "100 %",
    "sleepHistoryDateTimeStrLst": [
      "10_07_2022 00:58",
      "05:35",
      "04:00"
    ],
    "wakeUpHistoryDateTimeStrLst": [
      "10_07_2022 05:58",
      "00:35",
      "01:00"
    ]
  },
  "dateTimeDifferenceDurationData": {
    "screenDataType": 2,
    "dateTimeDifferenceStartDateTimeStr": "2022-07-13 16:09",
    "dateTimeDifferenceEndDateTimeStr": "2022-07-14 16:09:42.390753",
    "dateTimeDifferenceDurationStr": "24:00",
    "dateTimeDifferenceAddTimeStr": "1:00",
    "dateTimeDifferenceFinalDurationStr": "25:00"
  },
  "timeCalculatorData": {
    "screenDataType": 3,
    "timeCalculatorFirstTimeStr": "00:10:00",
    "timeCalculatorSecondTimeStr": "00:05:00",
    "timeCalculatorResultTimeStr": "00:15:00"
  },
  "currentScreenStateInstance": null,
  "calcSlDurStatus": null,
  "firstDurationIconData": null,
  "firstDurationIconColor": null,
  "secondDurationIconData": null,
  "secondDurationIconColor": null,
  "thirdDurationIconData": null,
  "thirdDurationIconColor": null,
  "firstDurationTextColor": null,
  "secondDurationTextColor": null,
  "thirdDurationTextColor": null
}''';
          expect(expectedFormattedJsonString, printableJsonString);
        },
      );
    },
  );
}
