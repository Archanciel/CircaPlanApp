import 'dart:io';

import 'package:circa_plan/utils/utility.dart';
import 'package:test/test.dart';

void main() {
  group('File renaming', () {
    test(
      'renameFile() to not existing file name',
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
      'renameFile() to existing file name',
      () {
        // renaming circadian.json to circadian.json-1

        String jsonFilePathNameStr = 'c:\\temp\\CircadianData\\circadian.json';

        File? renamedFile = Utility.renameFile(
            filePathNameStr: jsonFilePathNameStr,
            newFileNameStr: 'circadian.json-1');

        // renaming circadian.json-1 to circadian.json-1

        String renamedFilePathNameStr =
            'c:\\temp\\CircadianData\\circadian.json-1';

        expect(renamedFile!.path, renamedFilePathNameStr);

        renamedFile = Utility.renameFile(
            filePathNameStr: renamedFilePathNameStr,
            newFileNameStr: 'circadian.json-1');

        expect(renamedFile!.path, renamedFilePathNameStr);

        // renaming circadian.json-1 to circadian.json

        renamedFile = Utility.renameFile(
            filePathNameStr: renamedFilePathNameStr,
            newFileNameStr: 'circadian.json');

        expect(renamedFile!.path, jsonFilePathNameStr);
      },
    );
  });
  group(
    'Formatting',
    () {
      test(
        'formatJsonFileContent()',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian_formatJsonFileContent.json';
          String printableJsonFileContent = await Utility.formatJsonFileContent(
              jsonFilePathName: jsonFilePathNameStr);
          String expectedFormattedJsonFileCont = '''
{
  "addDurationToDateTimeData": {
    "screenDataType": 0,
    "addDurationStartDateTimeStr": "2022-07-12 16:00:26.486627",
    "firstDurationIconType": 1,
    "firstAddDurationStartDateTimeStr": "12-07-2022 16:50",
    "firstAddDurationDurationStr": "00:50",
    "firstAddDurationEndDateTimeStr": "12-07-2022 16:00",
    "secondDurationIconType": 1,
    "secondAddDurationStartDateTimeStr": "12-07-2022 16:00",
    "secondAddDurationDurationStr": "02:00",
    "secondAddDurationEndDateTimeStr": "12-07-2022 14:00",
    "thirdDurationIconType": 0,
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
    "dateTimeDifferenceDurationPercentStr": "70 %"
  },
  "timeCalculatorData": {
    "screenDataType": 3,
    "timeCalculatorFirstTimeStr": "00:10:00",
    "timeCalculatorSecondTimeStr": "00:05:00",
    "timeCalculatorResultTimeStr": "00:15:00",
    "timeCalculatorResultPercentStr": "40 %"
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
        'formatScreenDataSubMapFromJsonFileContent() addDurationToDateTimeData',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian_formatJsonFileContent.json';
          String printableScreenDataSubMapFromJsonFileContent =
              await Utility.formatScreenDataSubMapFromJsonFileContent(
                  jsonFilePathName: jsonFilePathNameStr,
                  screenDataSubMapKey: "addDurationToDateTimeData");
          String expectedFormattedScreenDataSubMapFromJsonFileCont = '''
{
  "screenDataType": 0,
  "addDurationStartDateTimeStr": "2022-07-12 16:00:26.486627",
  "firstDurationIconType": 1,
  "firstAddDurationStartDateTimeStr": "12-07-2022 16:50",
  "firstAddDurationDurationStr": "00:50",
  "firstAddDurationEndDateTimeStr": "12-07-2022 16:00",
  "secondDurationIconType": 1,
  "secondAddDurationStartDateTimeStr": "12-07-2022 16:00",
  "secondAddDurationDurationStr": "02:00",
  "secondAddDurationEndDateTimeStr": "12-07-2022 14:00",
  "thirdDurationIconType": 0,
  "thirdAddDurationStartDateTimeStr": "12-07-2022 16:00",
  "thirdAddDurationDurationStr": "00:00",
  "thirdAddDurationEndDateTimeStr": "12-07-2022 16:00"
}''';
          expect(printableScreenDataSubMapFromJsonFileContent,
              expectedFormattedScreenDataSubMapFromJsonFileCont);
        },
      );
      test(
        'formatScreenDataSubMapFromJsonFileContent() calculateSleepDurationData',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian_formatJsonFileContent.json';
          String printableScreenDataSubMapFromJsonFileContent =
              await Utility.formatScreenDataSubMapFromJsonFileContent(
                  jsonFilePathName: jsonFilePathNameStr,
                  screenDataSubMapKey: "calculateSleepDurationData");
          String expectedFormattedScreenDataSubMapFromJsonFileCont = '''
{
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
}''';
          expect(printableScreenDataSubMapFromJsonFileContent,
              expectedFormattedScreenDataSubMapFromJsonFileCont);
        },
      );
      test(
        'formatScreenDataSubMapFromJsonFileContent() dateTimeDifferenceDurationData',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian_formatJsonFileContent.json';
          String printableScreenDataSubMapFromJsonFileContent =
              await Utility.formatScreenDataSubMapFromJsonFileContent(
                  jsonFilePathName: jsonFilePathNameStr,
                  screenDataSubMapKey: "dateTimeDifferenceDurationData");
          String expectedFormattedScreenDataSubMapFromJsonFileCont = '''
{
  "screenDataType": 2,
  "dateTimeDifferenceStartDateTimeStr": "2022-07-13 16:09",
  "dateTimeDifferenceEndDateTimeStr": "2022-07-14 16:09:42.390753",
  "dateTimeDifferenceDurationStr": "24:00",
  "dateTimeDifferenceAddTimeStr": "1:00",
  "dateTimeDifferenceFinalDurationStr": "25:00",
  "dateTimeDifferenceDurationPercentStr": "70 %"
}''';
          expect(printableScreenDataSubMapFromJsonFileContent,
              expectedFormattedScreenDataSubMapFromJsonFileCont);
        },
      );
      test(
        'formatScreenDataSubMapFromJsonFileContent() timeCalculatorData',
        () async {
          String jsonFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian_formatJsonFileContent.json';
          String printableScreenDataSubMapFromJsonFileContent =
              await Utility.formatScreenDataSubMapFromJsonFileContent(
                  jsonFilePathName: jsonFilePathNameStr,
                  screenDataSubMapKey: "timeCalculatorData");
          String expectedFormattedScreenDataSubMapFromJsonFileCont = '''
{
  "screenDataType": 3,
  "timeCalculatorFirstTimeStr": "00:10:00",
  "timeCalculatorSecondTimeStr": "00:05:00",
  "timeCalculatorResultTimeStr": "00:15:00",
  "timeCalculatorResultPercentStr": "40 %"
}''';
          expect(printableScreenDataSubMapFromJsonFileContent,
              expectedFormattedScreenDataSubMapFromJsonFileCont);
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
  group(
    'convertIntDuration() removeMinusSign==false',
    () {
      test(
        'dayHourMinuteFormat==false pos int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '2',
            removeMinusSign: false,
          );

          expect(convertedStr, '2:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-2',
            removeMinusSign: false,
          );

          expect(convertedStr, '-2:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '20',
            removeMinusSign: false,
          );

          expect(convertedStr, '20:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-20',
            removeMinusSign: false,
          );

          expect(convertedStr, '-20:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos int 0',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '0',
            removeMinusSign: false,
          );

          expect(convertedStr, '0:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int -0',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-0',
            removeMinusSign: false,
          );

          expect(convertedStr, '-0:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '2:34',
            removeMinusSign: false,
          );

          expect(convertedStr, '2:34');
        },
      );
      test(
        'dayHourMinuteFormat==false pos HH:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '20:34',
            removeMinusSign: false,
          );

          expect(convertedStr, '20:34');
        },
      );
      test(
        'dayHourMinuteFormat==false neg H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-2:34',
            removeMinusSign: false,
          );

          expect(convertedStr, '-2:34');
        },
      );
      test(
        'dayHourMinuteFormat==false neg HH:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-20:34',
            removeMinusSign: false,
          );

          expect(convertedStr, '-20:34');
        },
      );
    },
  );
  group(
    'convertIntDuration() removeMinusSign==true',
    () {
      test(
        'dayHourMinuteFormat==false pos int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '2');

          expect(convertedStr, '2:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '-2');

          expect(convertedStr, '2:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '20');

          expect(convertedStr, '20:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '-20');

          expect(convertedStr, '20:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos int 0',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '0');

          expect(convertedStr, '0:00');
        },
      );
      test(
        'dayHourMinuteFormat==false neg int -0',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '-0');

          expect(convertedStr, '0:00');
        },
      );
      test(
        'dayHourMinuteFormat==false pos H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(durationStr: '2:34');

          expect(convertedStr, '2:34');
        },
      );
      test(
        'dayHourMinuteFormat==false pos HH:mm',
        () {
          String convertedStr =
              Utility.convertIntDuration(durationStr: '20:34');

          expect(convertedStr, '20:34');
        },
      );
      test(
        'dayHourMinuteFormat==false neg H:mm',
        () {
          String convertedStr =
              Utility.convertIntDuration(durationStr: '-2:34');

          expect(convertedStr, '2:34');
        },
      );
      test(
        'dayHourMinuteFormat==false neg HH:mm',
        () {
          String convertedStr =
              Utility.convertIntDuration(durationStr: '-20:34');

          expect(convertedStr, '20:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '2', dayHourMinuteFormat: true);

          expect(convertedStr, '00:02:00');
        },
      );
      test(
        'dayHourMinuteFormat==true neg int < 10',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '-2', dayHourMinuteFormat: true);

          expect(convertedStr, '00:02:00');
        },
      );
      test(
        'dayHourMinuteFormat==true pos int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '20', dayHourMinuteFormat: true);

          expect(convertedStr, '00:20:00');
        },
      );
      test(
        'dayHourMinuteFormat==true neg int > 10',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '-20', dayHourMinuteFormat: true);

          expect(convertedStr, '00:20:00');
        },
      );
      test(
        'dayHourMinuteFormat==true pos int 0',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '0', dayHourMinuteFormat: true);

          expect(convertedStr, '00:00:00');
        },
      );
      test(
        'dayHourMinuteFormat==true neg int -0',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '-0', dayHourMinuteFormat: true);

          expect(convertedStr, '00:00:00');
        },
      );
      test(
        'dayHourMinuteFormat==true pos H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '2:34', dayHourMinuteFormat: true);

          expect(convertedStr, '00:02:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos HH:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '20:34', dayHourMinuteFormat: true);

          expect(convertedStr, '00:20:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos 0H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '02:34',
            removeMinusSign: false,
            dayHourMinuteFormat: true,
          );

          expect(convertedStr, '00:02:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos 00:0H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '00:02:34',
            removeMinusSign: false,
            dayHourMinuteFormat: true,
          );

          expect(convertedStr, '00:02:34');
        },
      );
      test(
        'dayHourMinuteFormat==true neg H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '-2:34', dayHourMinuteFormat: true);

          expect(convertedStr, '00:02:34');
        },
      );
      test(
        'dayHourMinuteFormat==true neg HH:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
              durationStr: '-20:34', dayHourMinuteFormat: true);

          expect(convertedStr, '00:20:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos -0H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-02:34',
            removeMinusSign: false,
            dayHourMinuteFormat: true,
          );

          expect(convertedStr, '-02:34');
        },
      );
      test(
        'dayHourMinuteFormat==true pos 00:0H:mm',
        () {
          String convertedStr = Utility.convertIntDuration(
            durationStr: '-00:02:34',
            removeMinusSign: false,
            dayHourMinuteFormat: true,
          );

          expect(convertedStr, '-00:02:34');
        },
      );
    },
  );
  group(
    'extractHHmmAtPosition()',
    () {
      String histoStr =
          'Sleep 11-10 12:17: 6:12, 3:00\nWake 11-10 18:29: 0:30, 0:20';

      test(
        'first HH:mm, pos 20',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 20,
          );

          expect(extractedHHmm, '6:12');
        },
      );
      test(
        'first HH:mm, pos 22',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 22,
          );

          expect(extractedHHmm, '6:12');
        },
      );
      test(
        'last HH:mm, pos 56',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 56,
          );

          expect(extractedHHmm, '0:20');
        },
      );
      test(
        'last HH:mm, pos 59',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 59,
          );

          expect(extractedHHmm, '0:20');
        },
      );
      test(
        'last HH:mm, pos 60 > histoStr length',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 60,
          );

          expect(extractedHHmm, '');
        },
      );
      test(
        'Sleep date time at pos 3',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 3,
          );

          expect(extractedHHmm, '12:17');
        },
      );
      test(
        'Sleep date time at pos 13',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 13,
          );

          expect(extractedHHmm, '12:17');
        },
      );
      test(
        'Wake date time at pos 33',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 33,
          );

          expect(extractedHHmm, '18:29');
        },
      );
      test(
        'Wake date time at pos 40',
        () {
          String extractedHHmm = Utility.extractHHmmAtPosition(
            dataStr: histoStr,
            position: 40,
          );

          expect(extractedHHmm, '18:29');
        },
      );
    },
  );
}
