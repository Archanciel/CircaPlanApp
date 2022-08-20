import 'dart:io';

import 'package:circa_plan/utils/date_time_parser.dart';
import 'package:circa_plan/utils/dir_util.dart';
import 'package:test/test.dart';

void main() {
  group(
    'DirUtil()',
    () {
      test(
        'renameFile()',
        () {
          String notExistfilePathNameStr = 'c:\\temp\\circadian.json';

          File? renamedFile = DirUtil.renameFile(
              filePathNameStr: notExistfilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          expect(null, renamedFile);

          String originalFilePathNameStr =
              'c:\\temp\\CircadianData\\circadian.json';

          renamedFile = DirUtil.renameFile(
              filePathNameStr: originalFilePathNameStr,
              newFileNameStr: '2022-08-07 02.30.json');

          String renamedFilePathNameStr =
              'c:\\temp\\CircadianData\\2022-08-07 02.30.json';

          expect(renamedFilePathNameStr, renamedFile!.path);

          renamedFile = DirUtil.renameFile(
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
          String printableJsonFileContent = await DirUtil.formatJsonFileContent(
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
  }
}''';
          expect(expectedFormattedJsonFileCont, printableJsonFileContent);
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

          String printableFormattedMap = await DirUtil.formatMapContent(
              map: map);

          String expectedFormattedMap = '''
{
  "one": 1,
  "doubleTwo": 2.2,
  "hello": "Hello world !",
  "sub map": {
    "waouh": 111,
    "grr": 37
  },
  "coucou": "Coucou world !"
}''';
          expect(expectedFormattedMap, printableFormattedMap);
        },
      );
    },
  );
}
