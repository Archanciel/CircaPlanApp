import 'package:circa_plan/model/add_duration_to_datetime_data.dart';
import 'package:circa_plan/model/calculate_sleep_duration_data.dart';
import 'package:test/test.dart';

import 'package:circa_plan/model/screen_data.dart';
import 'package:circa_plan/model/transfer_data.dart';

void main() {
  group(
    'TransferData',
    () {
      test(
        'TransferData with AddDurationToDateTimeData only',
        () async {
          AddDurationToDateTimeData addDurationToDateTimeData =
              AddDurationToDateTimeData();
          addDurationToDateTimeData.durationIconType = DurationIconType.add;
          addDurationToDateTimeData.addDurationStartDateTimeStr =
              '09_07_2022 23:58';
          addDurationToDateTimeData.durationStr = '01:00';
          addDurationToDateTimeData.endDateTimeStr = '10_07_2022 00:58';

          TransferData transferData = TransferData();
          transferData.addDurationToDateTimeData = addDurationToDateTimeData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          AddDurationToDateTimeData loadedAddDurationToDateTimeData =
              loadedTransferData.addDurationToDateTimeData;

          expect(loadedAddDurationToDateTimeData.screenDataType,
              ScreenDataType.addDurationToDateTimeData);
          expect(loadedAddDurationToDateTimeData.durationIconType,
              DurationIconType.add);
          expect(loadedAddDurationToDateTimeData.addDurationStartDateTimeStr,
              '09_07_2022 23:58');
          expect(loadedAddDurationToDateTimeData.durationStr, '01:00');
          expect(loadedAddDurationToDateTimeData.endDateTimeStr,
              '10_07_2022 00:58');
        },
      );
      test(
        'TransferData with CalculateSleepDurationData only',
        () async {
          CalculateSleepDurationData calculateSleepDurationData =
              CalculateSleepDurationData();
          calculateSleepDurationData.status = Status.sleep;
          calculateSleepDurationData.sleepDurationNewDateTimeStr =
              '09_07_2022 23:58';
          calculateSleepDurationData.sleepDurationPreviousDateTimeStr =
              '09_07_2022 22:58';
          calculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr =
              '09_07_2022 21:58';
          calculateSleepDurationData.sleepDurationStr = '01:00';
          calculateSleepDurationData.wakeUpDurationStr = '00:30';
          calculateSleepDurationData.totalDurationStr = '01:30';

/*
"calcSlDurSleepTimeStrHistory"
List (4 items)
"13-07-2022 20:26"
"1:00"
"0:30"
"1:00"
"calcSlDurWakeUpTimeStrHistory" -> List (4 items)
"calcSlDurWakeUpTimeStrHistory"
List (4 items)
"13-07-2022 21:26"
"1:00"
"1:00"
"2:00"
*/
          calculateSleepDurationData.sleepHistoryDateTimeStr = '10_07_2022 00:58 05:35 04:00';
          calculateSleepDurationData.wakeUpHistoryDateTimeStr = '10_07_2022 05:58 00:35 01:00';

          TransferData transferData = TransferData();
          transferData.calculateSleepDurationData = calculateSleepDurationData;

          String jsonFilePathName = 'transfer_data.json';
          transferData.saveTransferDataToFile(
              jsonFilePathName: jsonFilePathName);

          TransferData loadedTransferData = TransferData();
          await loadedTransferData.loadTransferDataFromFile(
              jsonFilePathName: jsonFilePathName);

          CalculateSleepDurationData loadedCalculateSleepDurationData =
              loadedTransferData.calculateSleepDurationData;

          expect(loadedCalculateSleepDurationData.screenDataType,
              ScreenDataType.calculateSleepDurationData);
          expect(loadedCalculateSleepDurationData.status,
              Status.sleep);
          expect(loadedCalculateSleepDurationData.sleepDurationNewDateTimeStr,
              '09_07_2022 23:58');
          expect(loadedCalculateSleepDurationData.sleepDurationPreviousDateTimeStr,
              '09_07_2022 22:58');
          expect(loadedCalculateSleepDurationData.sleepDurationBeforePreviousDateTimeStr,
              '09_07_2022 21:58');
          expect(loadedCalculateSleepDurationData.sleepDurationStr, '01:00');
          expect(loadedCalculateSleepDurationData.wakeUpDurationStr, '00:30');
          expect(loadedCalculateSleepDurationData.totalDurationStr, '01:30');
          expect(loadedCalculateSleepDurationData.sleepHistoryDateTimeStr,
              '10_07_2022 00:58 05:35 04:00');
          expect(loadedCalculateSleepDurationData.wakeUpHistoryDateTimeStr,
              '10_07_2022 05:58 00:35 01:00');
        },
      );
    },
  );
}
